Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91F710E4
	for <kvmarm@lists.linux.dev>; Tue, 27 Dec 2022 13:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1672146227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itmwXqUo01mTV85no/9ZNLho2BNM+XUgesQju+SpFwM=;
	b=GGI0K3u/ZoS7YEeAPz8SZK7toYJMSk0sOFUJ93k+9P8LLPlt1OC+bwCchp7gjO1+zkg9Iw
	3Fu9/feuzr6NKunQWzNQUcATzpC60sGaXqZPCmAN0I7+gQlZupgvUmaBQYzr96uOcNOJpt
	ZRrXXOhxY6nAvkqnsp0vOlBvfYmEQ+c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-al1j6ULROiyc5y_rGIER3A-1; Tue, 27 Dec 2022 08:03:41 -0500
X-MC-Unique: al1j6ULROiyc5y_rGIER3A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C26A0101A521;
	Tue, 27 Dec 2022 13:03:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C14DC15BA0;
	Tue, 27 Dec 2022 13:03:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuan Yao <yuan.yao@intel.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Kai Huang <kai.huang@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 00/50] KVM: Rework kvm_init() and hardware enabling
Date: Tue, 27 Dec 2022 08:02:50 -0500
Message-ID: <20221227130249.1650197-1-pbonzini@redhat.com>
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
References: 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Message-ID: <20221227130250.vhHpZzwxtK5HJpOQNG3hHnfPKOchXrZ-NFHSMGDIHMk@z>

Queued, thanks.  I will leave this in kvm/queue after testing everything
else and moving it to kvm/next; this way, we can wait for test results
on other architectures.

Paolo


