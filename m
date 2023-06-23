Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951928835
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 12:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687524865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9fCMPOeXvmZRh+e8bRoilHrrW+K9gcC171wg8gjwxXk=;
	b=AIIAE35r585i+WzC3OkZsCl5UeXD9EaVfaAU1vsESpjb/nCMaO+UOrrsufMyods3PmRqu1
	oowrn4NYKVf2ypV7ZN7EZvepbJmcuYcItH9KPSEWfsRMBjTbylYu4TMuJJjyGv+Hn+yPdp
	TfGgkCoQTLaSSNDWGowq4r7CNs6GdWU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-5TjDrdBlOmy0RWPp0ZCtNQ-1; Fri, 23 Jun 2023 08:54:22 -0400
X-MC-Unique: 5TjDrdBlOmy0RWPp0ZCtNQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C3F3185A7A4;
	Fri, 23 Jun 2023 12:54:21 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.208])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EBF14F41C8;
	Fri, 23 Jun 2023 12:54:18 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>
Subject: [kvm-unit-tests PATCH 0/2] Rework LDFLAGS and link with noexecstack
Date: Fri, 23 Jun 2023 14:54:14 +0200
Message-Id: <20230623125416.481755-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5

I noticed that the latest version of ld (in Fedora rawhide) emits
a warning on x86 and s390x, complaining about missing .note.GNU-stack
section that implies an executable stack. It can be silenced by
linking with "-z noexecstack".

While trying to add this switch globally to the kvm-unit-tests, I
had to discover that the common LDFLAGS are hardly used anywhere,
so the first patch cleans up that problem first before adding the
new flag in the second patch.

Thomas Huth (2):
  Rework the common LDFLAGS to become more useful again
  Link with "-z noexecstack" to avoid warning from newer versions of ld

 Makefile                | 2 +-
 arm/Makefile.common     | 2 +-
 powerpc/Makefile.common | 2 +-
 s390x/Makefile          | 2 +-
 x86/Makefile.common     | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.39.3

