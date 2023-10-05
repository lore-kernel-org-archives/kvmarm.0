Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2D31373
	for <kvmarm@lists.linux.dev>; Thu,  5 Oct 2023 01:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cifavt6D"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5a4f656f751so7294737b3.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Oct 2023 18:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696470270; x=1697075070; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=brblM1cgPenAQfqP7iVYjJGMX2iIkPxCWUe6XyphfiA=;
        b=Cifavt6DUVDjORflG972MylbIJ/F73mhkOfgKN5vvTMTDdwMFQxctLhTf8RnZSeQ9c
         ws7Iuj92zz+dEggpoNhzv0CxBoQ2AfZdDAN7jBWZjPXdnAOx9DMKIeOLpNAqUwTV8nVS
         K/Yoisw+av2yH1TnzjwhKQOh1o38ZFLc1RvoJT9yR5nRnHNq4SDyj99H3y7fNNk9KLKV
         IeyEbsR+sfNcSYtC4eNUx5lZgEziCJpoEnNiMgAc3BJfBPRLzFqnVfxkAE8HcgBY4zNO
         spC4KYImPBbHW0s6Mi4oacVmMDHeznw3ZTGpepR/8NAmOfNwPPTQtyGNqF3OjpxLvpG6
         mqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696470270; x=1697075070;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=brblM1cgPenAQfqP7iVYjJGMX2iIkPxCWUe6XyphfiA=;
        b=bP+0ysqpYxRlAys/nkcMiJEk2dXarrcKgRwe3yE3kSwiMRDsne2UUACCP8aKi7Rtwf
         OjJ+qPYYL31GkzBwS5VIcbgaPXFw/hcE2p+WuYvxMoqzPAK68I3OlyF6YgM4KRQ1iY3/
         BnjUyA2tbZ7aROw8OSN4fM0h7i82JRxpp4jXuiTetwmxqFPh5kpVpm5V5uNnSaB9QSWw
         XH6Wn4YvjQaml+mQYESkD+VF8SenMHDZxoSX7jCN2JueuB1fBgl3F0an++bcQyw3mTpX
         4H4A7qO/+UtRIjjhMCFQ8/zhGkR7sERxSXN3xT81QimotGjQR8dT6PcIzGnRpJdME6pY
         NkkA==
X-Gm-Message-State: AOJu0YyibX+aSYfa2euaFWNr+ZiacvUp0JFMyVS6yWh/V+55rTDfmlFT
	CQAkyxK5h4Vkdgt7uG7oH10vOfpLsjo=
X-Google-Smtp-Source: AGHT+IFS+qnZ1QlDJ/CSV8U3hLt+JuAx5JZDqupY2JuMBGE0zT3Mhw/S/rlbAo3YBzz7Lh9UPHdd4OtkY7c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:741:0:b0:d81:bb31:d2fa with SMTP id
 s1-20020a5b0741000000b00d81bb31d2famr61515ybq.3.1696470270584; Wed, 04 Oct
 2023 18:44:30 -0700 (PDT)
Date: Wed, 4 Oct 2023 18:44:29 -0700
In-Reply-To: <20230908222905.1321305-11-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
Message-ID: <ZR4U_czGstnDrVxo@google.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="us-ascii"

Eh, the shortlog basically says "do work" with a lot of fancy words.  It really
just boils down to:

  KVM: Let callers of __gfn_to_pfn_memslot() opt-out of USERFAULT_ON_MISSING

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> Change the "atomic" parameter of __gfn_to_pfn_memslot() to an enum which

I've pushed back on more booleans multiple times, but IMO this is even worse.
E.g. what does an "upgrade" to atomic even mean?

Since we have line of sight to getting out of boolean hell via David's series,
just bite the bullet for now.  Deciphering the callers will suck, but not really
anymore than it already sucks.

kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
			       bool atomic, bool interruptible, bool *async,
			       bool write_fault, bool *writable,
			       bool can_do_userfault, hva_t *hva)
{
	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);

	if (hva)
		*hva = addr;

	if (kvm_is_error_hva(addr)) {
		if (writable)
			*writable = false;

		if (addr == KVM_HVA_ERR_RO_BAD)
			return KVM_PFN_ERR_RO_FAULT;

		return KVM_PFN_NOSLOT;
	}

	if (!atomic && can_do_userfault &&
	    kvm_is_slot_userfault_on_missing(slot)) {
		atomic = true;
		if (async) {
			*async = false;
			async = NULL;
		}
	}

	/* Do not map writable pfn in the readonly memslot. */
	if (writable && memslot_is_readonly(slot)) {
		*writable = false;
		writable = NULL;
	}

	return hva_to_pfn(addr, atomic, interruptible, async, write_fault,
			  writable);
}
