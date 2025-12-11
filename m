Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EDD314B90
	for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 17:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765475672; cv=none; b=u105hZAbsDqLGl8OwSAygE7K/k7HeTBl/9itYDG9DZFYZ7yIHn7JBqVnOU9TEPq1rEUAxvwBWdsb77lxrnJCtweb+mJXFQheBz/RCFAPiBg6SvhIxLWbKl7b6FkBPU6MjTwt2zWTTmox4K9tPEAWGsmA6j+NQ7mTbtC1WnxJHw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765475672; c=relaxed/simple;
	bh=T7pjnhmn3U59zEBpymWdkY81rHaunzt4BBUTKm53zwg=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=A6ItJrrlH2iZEM4afGb5II2AIzrktWhqrumrN8lSMHV2uUD0LGm/lykdh3GYzhh1P4h2hkxSBGc2GbrLHeIGiJbgb7NNQZ43YdHu9xvTl7l9dq2JSPmal0wuKB5sKIRvb19P/qiKn2vTsHS4ZfLmFbiOvoAt1wBoUIAW1maE/OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qtr1MYk5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qtr1MYk5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765475670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=T6K6T28DoHunvDKpuEqj+Ae7g7B6b79uBdSlE9I255k=;
	b=Qtr1MYk53uz2Wgx5QlJkFxQYKjDfowqAFzV8YwRjxH9z1S7goyTaYcClZFYJeXOlnaTBJ/
	lSl5j9N14rp5wHwCTnBZ+2nGbf0+ZL04SRUgF+DIuF+CrAgeRjpVIvKpVTHfeMDd72TCiX
	CykfOPr4ZqjpZkzkNg/1MVU1TycFYiU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-aynAIR-QMPaaRARdBDyxKw-1; Thu, 11 Dec 2025 12:54:29 -0500
X-MC-Unique: aynAIR-QMPaaRARdBDyxKw-1
X-Mimecast-MFC-AGG-ID: aynAIR-QMPaaRARdBDyxKw_1765475668
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47775585257so2694555e9.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Dec 2025 09:54:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765475668; x=1766080468;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T6K6T28DoHunvDKpuEqj+Ae7g7B6b79uBdSlE9I255k=;
        b=DvgyOuqIQsGR7AEh2AEhDP//ILfHGzkHTbvAp7xLpSgEns0YmieUp0v7gbm8ai189F
         3ef5XE/erOKtg4eIMZekZsCOf7+4/NDbhgLpsi65Zl4KE5533Swz+m0yDoBhVZDO0QC9
         mDLThOoEhQqga9QBgI/7IDLJZNULCCij3/wxPMNCHrwpvnDC6uX446MhswMIPTJ0chs+
         Nkkfz6a/wdB2JyJrEIKZqpqUv4hSz7OogX+7acgI+McJ/CK+ZMclXChj7A+5vhM/OkuU
         G4N2O/2wqB3m1kII98XPzRNIQ0ZhRC+fZYymvNOc0WL4bkIeob+uLaCy5hN+2CPMZWTv
         GxJg==
X-Gm-Message-State: AOJu0YwHhnPALabJXmaREgwIF8//e7B4zSMSAHhKSC09ddYM2AxGwcW/
	5jHXjv5khoCWuS1d23KvXpLcjb/mzJxOAG8c393adKQfA3oT2r3vGJLUy0KFnUzB/pYyM/FWohm
	uTmMlyEu8Mmv64tGl1xH7w3lHFqnjehHob2EsabK1vcBTqxybxUhDaPvqjA==
X-Gm-Gg: AY/fxX4V/tWELQtOfVGyv3Tv0bb1vZsZFYZacC8zecX49sXaNzCccUkzwnXVUgIEmf0
	f/4qf2P4NHKcINjKUF0liw31bOZ7qSNvGjKY9xc5G1pvlbhaO797APFJhwo1NAKz8YtH+P0HwvA
	ojGHosQAP7Nue02/by6Gv7AXw4xVt2Py6721ybPBw2So+jIhiaFM31cbwRSuMRVihBsY+tnuECH
	CMvi3uED8tfI9SpnWD0ewZ2XnFJ+m9saGZKowmWMajHp37awFwxLrlCVAGtav51Lrm4A0LrL5ee
	SdIx7V/5DIyyJ/1KmTqPBGDY1Wu8NXl7ZqXvZGwLkNyO8ON1SpfQbkBG2YrcgdehkqraCIAT/Ek
	tPJhmcPps3eD6q7SqaY1IhQ4jFq20CtiLsi5dE6kzgl7NzOvO/UXOE9WBgZw=
X-Received: by 2002:a05:600c:3113:b0:477:7768:8da4 with SMTP id 5b1f17b1804b1-47a856249c2mr52649465e9.7.1765475667692;
        Thu, 11 Dec 2025 09:54:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHq0XWIIYYXwcFnEjkxgRdCPkys75t8d81jvLJeRmVOioi3bdjzbj+DUjq8WDsmC59BFVUkYA==
X-Received: by 2002:a05:600c:3113:b0:477:7768:8da4 with SMTP id 5b1f17b1804b1-47a856249c2mr52649305e9.7.1765475667310;
        Thu, 11 Dec 2025 09:54:27 -0800 (PST)
Received: from rh (p200300f6af498100e5be2e2bdb5254b6.dip0.t-ipconnect.de. [2003:f6:af49:8100:e5be:2e2b:db52:54b6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a89da3ed7sm46616035e9.4.2025.12.11.09.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 09:54:26 -0800 (PST)
Date: Thu, 11 Dec 2025 18:54:25 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Jiaqi Yan <jiaqiyan@google.com>, Oliver Upton <oupton@kernel.org>, 
    Marc Zyngier <maz@kernel.org>, Shuah Khan <shuah@kernel.org>
cc: kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org
Subject: sea_to_user sefltest failure
Message-ID: <1478ac09-8134-5551-13b6-c7be096262af@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xzwn44yvhRTwyFUXH-SwFepeh8qkJuR1fmAkxAJrBp8_1765475668
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hi,

sea_to_user fails for me with:

Random seed: 0x6b8b4567
==== Test Assertion Failure ====
   include/kvm_syscalls.h:58: mem != MAP_FAILED
   pid=4923 tid=4923 errno=12 - Cannot allocate memory
      1  0x0000000000405afb: __kvm_mmap at kvm_syscalls.h:58 (discriminator 3)
      2   (inlined by) kvm_mmap at kvm_syscalls.h:65 (discriminator 3)
      3   (inlined by) vm_mem_add at kvm_util.c:1036 (discriminator 3)
      4  0x0000000000402377: vm_create_with_sea_handler at sea_to_user.c:278
      5   (inlined by) main at sea_to_user.c:324
      6  0x0000ffff8d0a621b: ?? ??:0
      7  0x0000ffff8d0a62fb: ?? ??:0
      8  0x000000000040282f: _start at ??:?
   mmap() failed, rc: -1 errno: 12 (Cannot allocate memory)

this could be related to my config?
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
# CONFIG_PERSISTENT_HUGE_ZERO_FOLIO is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_TRANSPARENT_HUGEPAGE_NEVER is not set
CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER=y
# CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ALWAYS is not set
# CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_WITHIN_SIZE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_ADVISE is not set
CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER=y
# CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ALWAYS is not set
# CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_WITHIN_SIZE is not set
# CONFIG_TRANSPARENT_HUGEPAGE_TMPFS_HUGE_ADVISE is not set
CONFIG_PGTABLE_HAS_HUGE_LEAVES=y
CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP=y
CONFIG_ARCH_SUPPORTS_HUGETLBFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING=y

Looking at the code smth like this would skip the test:
get_backing_src_pagesz(VM_MEM_SRC_ANONYMOUS_HUGETLB);

..or is this not worth the effort and my config is too weird?

Thanks,
Sebastian

