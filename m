Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7D319F
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 00:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708468; cv=none; b=pWY41VRSEGsMTw/q4cXShnOHj4mE1i027vgPKweGGJLcqEuGmb2EatKLMHZeSdn9V6BWBOP0mkriJwPEFY0qoMjZGBSymiZppdOUwRlecG6EpxUd6zfNFOQr98LDll8ZQeOiPChOV/WGRkGeTsPNnRizcf84EtTYLLj5kicOJm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708468; c=relaxed/simple;
	bh=nvDmKcqgZYU/OYfaKUhpOLSwCsZryNI7cthDCd2CKBM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZcJ9iE+kYgTTpJiIDN7WOPY5n9WYorTv6BHL5M2Z3W/AShwrBT8k6h13T8uvHL5eUUzPaHsxKqQKl1iTDZVNGbuu5uUYvNDbMNSCdoNXFgUN+8Qb+/5HFncx+6gj1yUUkF+e0QE0kHb5RrVfNFPMzsDdLvmcpcYOUSDdDwSRUe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ervnlVG7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ervnlVG7"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5ce12b4c1c9so3969431a12.1
        for <kvmarm@lists.linux.dev>; Tue, 09 Apr 2024 17:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708465; x=1713313265; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sB8TObMn2LzyNJKKLxOJUwJM9wTkM/WYNATrUKjs+Gk=;
        b=ervnlVG7f55ezKyeMKsX23b1OHgm8X75HUFVdobsjqyTeZtAbBRW4GmIgDTXR0wd+T
         p4RQq3CHhWoWjeoGT4wOZxLU2jcvP4pfP3yX0BxonhthucDKCEIhJ1k6MHvHytRKdeiI
         TDegCtXUCW0oVrhWPiAmc2rNerQ/6KQ9ljEGyWDgauftQbNuSB4lIWmovtTvxm/DVuCn
         CaMpcW+sZUkavOkv/imTG/lT3EnRCz/lnTzplS07NawH3aRQ0dNr0yGDislw2du+vegK
         QeBNfYbOLIfGEhEu4rlsWnmAmDaTM5VariDrInMuJANngs6NcMMj69OqluSq3KhmAOCj
         LbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708465; x=1713313265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sB8TObMn2LzyNJKKLxOJUwJM9wTkM/WYNATrUKjs+Gk=;
        b=Q2XI8724HipHn6NuqTp/HtUQaUDTdCFJ1+1/+GG1Sh3fRckToEhXsibLkwClN6JeQw
         ANFxY2TjiiRlghcwTIGQjSxDCUwzFvOSmq6NYYDrfo+7Jcz6TI1JJ+nOiwGjwlspgA+t
         qSET0UkvFp5nEoK25lPiHTZFKo7K7h2bW/dL9WvZ0pCA5Zez2TRlGLKBtHfHbfrtwzMp
         J1Du/DsV4stKtpD0Em7ve7Xf74KH5NuMKkT9NKayT7GGMn9VzU6ud+cXEUCw6fvRKcam
         KcO2IcBXHokgqRIM+iU9grVs4sJm+rxe+EFabIbANevR+ipFjN6s+1s6LwSeajhZQMS9
         ZHPg==
X-Forwarded-Encrypted: i=1; AJvYcCUyoUBUiChfHwNYocy4V4tNYyW2P2WeIZCpbc7eKmgDRApZxtyCeMChjrmup1/YGOJfDtFwRfBbfNJpe/laC2v0p5B72bdP
X-Gm-Message-State: AOJu0YzTCrTojFCFErt9i5qZ6lo0e76ppt44gwpetaQQO45BAu7Pf9jD
	mrWL2SkLGI/C1HWWsF+nqRV9lujS/U9cefTUhlMjn/Fm2rG8GIyP0wgAocoXCDJSyTsr/6w0vXk
	dRQ==
X-Google-Smtp-Source: AGHT+IFjH6w0Pze5H1cHo/Xc/jOJhLTcuS83dS5VOg9J1IvpNVkCfl2XKYF62JEhUaXYDBmtvq28KE+rWPc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:ec04:0:b0:5dc:8645:fd8 with SMTP id
 j4-20020a63ec04000000b005dc86450fd8mr3162pgh.1.1712708465026; Tue, 09 Apr
 2024 17:21:05 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:46 -0700
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270376781.1586271.10159724514702496320.b4-ty@google.com>
Subject: Re: [PATCH v7 00/14] Improve KVM + userfaultfd performance via
 KVM_EXIT_MEMORY_FAULTs on stage-2 faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Anish Moorthy <amoorthy@google.com>
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, dmatlack@google.com, 
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com, 
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"

On Thu, 15 Feb 2024 23:53:51 +0000, Anish Moorthy wrote:
> This series adds an option to cause stage-2 fault handlers to
> KVM_MEMORY_FAULT_EXIT when they would otherwise be required to fault in
> the userspace mappings. Doing so allows userspace to receive stage-2
> faults directly from KVM_RUN instead of through userfaultfd, which
> suffers from serious contention issues as the number of vCPUs scales.
> 
> Support for the new option (KVM_CAP_EXIT_ON_MISSING) is added to the
> demand_paging_test, which demonstrates the scalability improvements:
> the following data was collected using [2] on an x86 machine with 256
> cores.
> 
> [...]

Applied 1,2, and 4 to kvm-x86 generic, and 10-12 to kvm-x86 selftests.

I skipped all KVM_CAP_EXIT_ON_MISSING as per our decision to hold off until we
see the KVM userfault stuff.  I skipped the docs patch because it would require
more massaging than I wanted to do when applying.  And lastly, I skipped the
"Add memslot_flags parameter to memstress_create_vm()" patch because it would be
dead code without the exit-on-missing usage.

Please take a look at the selftests commits in particular, as I did a decent
amount of massaging when applying.

Thanks!

[01/14] KVM: Clarify meaning of hva_to_pfn()'s 'atomic' parameter
        https://github.com/kvm-x86/linux/commit/ed2f049fc144
[02/14] KVM: Add function comments for __kvm_read/write_guest_page()
        https://github.com/kvm-x86/linux/commit/a3bd2f7ead6d
...

[04/14] KVM: Simplify error handling in __gfn_to_pfn_memslot()
        https://github.com/kvm-x86/linux/commit/f588557ac4ac

...

[10/14] KVM: selftests: Report per-vcpu demand paging rate from demand paging test
        https://github.com/kvm-x86/linux/commit/2ca76c12c48b
[11/14] KVM: selftests: Allow many vCPUs and reader threads per UFFD in demand paging test
        https://github.com/kvm-x86/linux/commit/df4ec5aada9d
[12/14] KVM: selftests: Use EPOLL in userfaultfd_util reader threads
        https://github.com/kvm-x86/linux/commit/0cba6442e9e2

--
https://github.com/kvm-x86/linux/tree/next
