Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DAE28F4
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675864902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B/oxBv4GyMlmg4LCOb2+pqMxLhVHvEGbOFN4G7DG1xk=;
	b=MhTKQs/KZmrsMQqoAigdTfscXC2CvjGijLg7PphdkyV7jG1KuQnk66JftfrZdj31SMNifQ
	eGQeXyoA/y1bKMVGGZJ4Vuce4FhzKwAMalPM1gXg37Bv3jn3jeXwHlYrgdlLVfx5QelZ56
	agU35Q7kLbh+YHXWy+NNVeu3kbkU8Pg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-lS0izmB0OKqVYfkJTapWdw-1; Wed, 08 Feb 2023 09:01:39 -0500
X-MC-Unique: lS0izmB0OKqVYfkJTapWdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 627871C08976;
	Wed,  8 Feb 2023 14:01:38 +0000 (UTC)
Received: from thuth.com (unknown [10.39.193.64])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 976E8140EBF4;
	Wed,  8 Feb 2023 14:01:34 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Gavin Shan <gshan@redhat.com>,
	Steven Price <steven.price@arm.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 5/6] KVM: Standardize on "int" return types instead of "long" in kvm_main.c
Date: Wed,  8 Feb 2023 15:01:04 +0100
Message-Id: <20230208140105.655814-6-thuth@redhat.com>
In-Reply-To: <20230208140105.655814-1-thuth@redhat.com>
References: <20230208140105.655814-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

KVM functions use "long" return values for functions that are wired up
to "struct file_operations", but otherwise use "int" return values for
functions that can return 0/-errno in order to avoid unintentional
divergences between 32-bit and 64-bit kernels.
Some code still uses "long" in unnecessary spots, though, which can
cause a little bit of confusion and unnecessary size casts. Let's
change these spots to use "int" types, too.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9c60384b5ae0..cd46467252a9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4475,7 +4475,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 	return 0;
 }
 
-static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
+static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 {
 	switch (arg) {
 	case KVM_CAP_USER_MEMORY:
@@ -5053,7 +5053,7 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
 static long kvm_dev_ioctl(struct file *filp,
 			  unsigned int ioctl, unsigned long arg)
 {
-	long r = -EINVAL;
+	int r = -EINVAL;
 
 	switch (ioctl) {
 	case KVM_GET_API_VERSION:
-- 
2.31.1

