Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD392FD7B1
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 00:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788309536; cv=none; b=SXXPCKd4kB6lkKCIODGr48DBmcHxS+jRH8zYRgrBP9qXJbs26DuHHjqVpj3mgLGwheEbrZiozQNbmDDWbHRrcwkGz+kVRSG+9lMyNqXuxQk4OK3utxO2iGifv3FGRiRNktKd36FD5mbNO4Pr852JgScrpuPFg+nrAUaJKo1UZQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788309536; c=relaxed/simple;
	bh=dM8UMjdfpzrInG7yBCOavPUVK2/x4vlb0fefgS3K6Yw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SaepJdYIFkmy7gVGaDdHfH5eg5RdeDdZXbb8rbQAtDMmxl+Lzrtpoi3WKV6F4CEPj416d9peS2LRTGFgG/JxwULgPA2uiXAjU3eJRWetghxoUIwsqmUw2+o1JdMHEOzOPpoxcAwdS4hm8So+bSwNpNSBibMj1T2P27cotav9MWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GZaVMx6n; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GZaVMx6n"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso5479015ad.0
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 17:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788309534; x=1788914334; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FaTmFFkWvtpI1wxK9lbUH5Q49TqxcdmMs9wtskLlSB4=;
        b=GZaVMx6n3jXV9rCTf4jAwySRoWaa2MmKfEpvvhjP8/eGvMT7szYyZC6CFn6YgbNCHD
         fyrHdWWque12q8Iol4eaqz9Lu4G891S9ZAyTBV+5OKq4MYyBAqEkck8u5JDjrNnnTrlk
         hsOaiPIPero7b62pWCq2r+s1XRuqfvfZLfvmxf/nCb8jk37BIIMc5uDPnEp1ReVF+89k
         LLJVvy19Je6okG1bipKpRx3min1ZXEYow9r9mhOxkM+IPethWbv8QxnOjzqR+eCrSjRA
         Jt+5CtmgqASmSXf8/ho4z/27wIQeY2W4QvVU9pUCOqthBEfZ1bcB6F7yco1IfxYw8ADZ
         7NMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788309534; x=1788914334;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FaTmFFkWvtpI1wxK9lbUH5Q49TqxcdmMs9wtskLlSB4=;
        b=XXKHxkl9m9lZz1flSjdxRZ7NL324jFDKQ+SF4gj6yZfZrDJiOoby9bhO2tUEgUBUWt
         H+G7N0jboad/sXO+NfA/gJh6VViXAOyXzqhyoSKP7kif2g9Upoue9ZqfNOqa9RBG6T3C
         LySDI4NaIwzAm8/6cJ+/abC5X735bpW++3eaklkkqnIrvwVc+vSBTzqvoTaT+qAdIH/G
         6Otv1UHWJsuVgSH7Zfg6N1EomQlaPqvK1+e7/ew64YKfhXR+VmCcQlMA4ivQv5zNxIze
         /IAGwO0nlkvLDVJXHWSS9kIxFGPoV18/b+0NavoqujVYW1rZ7lrw431SRv8KTLndBU8A
         rSkQ==
X-Forwarded-Encrypted: i=1; AKwUvByeZd6dmAnYT3ghKEcVPRpWrtwk3u5B28N6ky2EjEhw6UeQ6Cr0OBCS2UKu9cHJ7nmAKnreS6g=@lists.linux.dev
X-Gm-Message-State: AFuF++nby8+ppiNNmKMUq9aMo70IZND9edzwftYmetjosQHKkqKv4SNZ
	3yaeYcbITV7/sMCpt0V/hfloBabMlJy1nlY9LT4ROFtGQcsVUBBUUVPaSgbXHcjjh6xWjZ4o5WH
	DRSx6dA==
X-Received: from plgf7.prod.google.com ([2002:a17:902:ce87:b0:2cc:6063:a658])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:26c6:b0:2d8:d4cc:be67
 with SMTP id d9443c01a7336-2daec73f1d2mr14199535ad.20.1788309534336; Tue, 01
 Sep 2026 17:38:54 -0700 (PDT)
Date: Tue, 1 Sep 2026 17:38:53 -0700
In-Reply-To: <20260831144802.834315-4-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-4-seiden@linux.ibm.com>
Message-ID: <apdwHcdy2iYRTrww@google.com>
Subject: Re: [PATCH v7 03/23] KVM: Allow KVM implementations to switch off
 MMIO independent of Kconfig
From: Sean Christopherson <seanjc@google.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 31, 2026, Steffen Eiden wrote:
> Only defining KVM_MMIO is not flexible enough for multi-KVM systems
> where one KVM implements MMIO but others do not. Solve this by
> additionally testing for the non-existence of KVM_NO_MMIO before
> including MMIO code to KVM.

Ewwwww.  IIUC, s390 ends up with two KVM modules, i.e. there really are two different
KVMs being built.  Rather than have a KVM_MMIO and NO_KVM_MMIO, I vote very
strongly to drop CONFIG_KVM_MMIO entirely and replace it with __KVM_HAVE_ARCH_MMIO,
a la __KVM_HAVE_ARCH_VM_FREE and others.  Tracking two separate macros is going
to be annoying to maintain, and will definitely be confusing for non-s390 people.

It'll mean linking in an emtpy coalesced_mmio.o on s390 when building without arm64
support, but I'm guessing that won't be at all common for s390 builds.
