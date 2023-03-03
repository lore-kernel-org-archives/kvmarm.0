Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43DB1851
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 04:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677816664;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i5FedhhMXmT7C9gajU5UIqVoxccypA6ZX2Fyp9n5EPE=;
	b=Wp2m3EhjOZwCZbeZZw7BypuZ7WlBpOopsmlKW5JWP7Y4VjH+78Zfi6BkxRW4793NO8lDxg
	DlLoqNa3oT5pLe5tbxRVypoSkiOw/Ui0JWQpx0lFf0+q5MGdZEiWltOQFI9a75wkXjeI3D
	Bf92xL26eGmFwatofimxWBww48yJaBU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-Yr58FajHPvqxhtu8toW25w-1; Thu, 02 Mar 2023 23:11:00 -0500
X-MC-Unique: Yr58FajHPvqxhtu8toW25w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CC231871D97;
	Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 758E3140EBF6;
	Fri,  3 Mar 2023 04:11:00 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvmarm@lists.linux.dev
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/2] Clean up the arm/run script
Date: Thu,  2 Mar 2023 23:10:50 -0500
Message-Id: <20230303041052.176745-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

Using more simple bash command to clean up the arm/run script.

Patch 1 replace the obsolete qemu script.

Patch 2 clean up the arm/run script to make the format consistent and simple.

Changelog:
----------
v2:
  - Add the oldest QEMU version for which -chardev ? work.
  - use grep -q replace the grep > /dev/null.
  - Add a new patch to clean up the arm/run.

v1: https://lore.kernel.org/all/20230301071737.43760-1-shahuang@redhat.com/

Shaoqin Huang (2):
  arm: Replace the obsolete qemu script
  arm: Clean up the run script

 arm/run | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
2.39.1

