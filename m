Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F87E55B
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 08:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949337; cv=none; b=SYtQkndFvaIiUyPTazWInvwJUU74Lxxb/LlyAwSFBbNuNZXgIWB5FVTD+K7Xb7cJZTwXQixHE3gFdrLsGE86mVqZo5wtkLQ7qIODFTmdL4U2em2HgybGqHhfqwBBrLzPg8TxavvPZ5/K/mB8X5j/O8LCxM9yjMvHdsATLjj9hiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949337; c=relaxed/simple;
	bh=sOdpA6ePDmomXzo1Y2B+Mmkj9rNOUEog8vH9h84ed5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQMReTu0hd+2QIHdYUQhRu3e+z1twpjpvfd2uRv8i7FG7TLm1P6CCsT/Gm2VfL2Jre2SSrytaPClV/ISFWpnj+lD4DEdRpHXcmcJUMyY2YimosVgGZgDYXawv7dBxeJ/o/fKNWUt4LfNpN4DPPTEyQgWa1IO5DqMa+v1I70pQRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jRKovPDR; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jRKovPDR"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso138221cf.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 01:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753949335; x=1754554135; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GnPE+sz1C/80U9yCW9/f/ei/+/2FFUemOvS6oEBnVic=;
        b=jRKovPDRMdtVKvjCl4ekdmHF1I4WeQ6CMg+dE6j50uTlW30uaC3L+wLIDm0dsBGBx0
         uMFROWLoi9amlFMcpSCcWWeIHuLV64aOMBT8wfCN1tRR2IzpMj0PW0LlClY8rxc0aJ+0
         Z7GlCDh+WYOEneAdHfH8lp0RpGoE6TWaEOYgP+xgVC1q56z3IbZcuWl6HjqBkSccWMTE
         OTy8W5IaDVIDPAKiLzwdxllTpWdCWcFL5lSK83Oz6xEyCWDozCDHecK0XNhvFTrCH/FK
         NGx9tWoqGi1j+D80Lzj/nE1fM5W63gJJAYVJ7vb714eHoxd2jtq4Ibj2gwKpCFezZkr3
         CXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949335; x=1754554135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnPE+sz1C/80U9yCW9/f/ei/+/2FFUemOvS6oEBnVic=;
        b=k0hClUYJeO3q+vq/ABE6rSkLF+vvqNbaJ9SBcNTKvgKEEgv3nAd4QAUd9l5mCB+Ovp
         LI1uxYPaDjBWyQnws7lm+SHfGFJu6U1fPA0YxrsJyjWubgSRGDcAVBFRxZ3kxU/gnWpv
         mw/KaDuAiNkKQSk2zUhPf9JCU8paPfEKlrmXs/b+zJmm1gLMp1ih+gqEzzln045so2uZ
         06vLNVJmm5qG6oCbBRMv+jxirAwYlmpSkTBss66GnM7QDv0NatW6M0kCyprcsZbdqLeL
         dAIa+2LLPyFVtIH5eLjQ94Au3BQXWv0CWJoBcXE2T4jruyx1EwaN/lYqDE31XD4PYznd
         5dZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/fC9psJN0jGqvHHvF1P5FKgjS9hNoY8BNrwD/QyZLg0mO2B3fas+FpwByinLGW0Ehvh3wUtM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0XHnfJ4V5Mp3qRCYvwxHLx+fanxTRiIqWHZMJotZIPE6kl+qw
	+wiIJsRGDfMsQ01u1Rzctl6M4sB1/dHIGtZx09t2u/qAmigyBhCdcXltUdMGcVVrbJ9QobhQqBg
	QPWCmtuWO6mvm/JhIif6ewCg9YEU4ADFLj3MK9zGM
X-Gm-Gg: ASbGncvAiswQti8ZzP6i3p5drH1/YVjaXA9OijP54KghpCX0cL9Jv5jjwK6ICfJjETy
	IEENSq7e6xlr2DR7EvHkqpDJtjHJv/83sMpwkHw0krO3UOFWjTNEdE91JLqawWXO/QcSsQ2T5a/
	19qqLPhbSVma391k0/dCqNV8XiP6ZhfyAeIY3PWwZqAoLrQlpD7/rKwRI+qYB1TMWnCniE/1Up7
	kBHgI4=
X-Google-Smtp-Source: AGHT+IFK/wJp553R4XjzZSWJ+dcd/8ojrcK2vt8dKw6Dg/D6YDKGLkDZhQfaq4WdtYxdsAtQNGiLyd6uqBH+0njZkJk=
X-Received: by 2002:a05:622a:178c:b0:4a6:f525:e35a with SMTP id
 d75a77b69052e-4aef1c6158fmr1665301cf.9.1753949334737; Thu, 31 Jul 2025
 01:08:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <20250729225455.670324-4-seanjc@google.com>
In-Reply-To: <20250729225455.670324-4-seanjc@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 31 Jul 2025 09:08:18 +0100
X-Gm-Features: Ac12FXwMtfUYkRsjJ3iXPfnzRPX0pAHczqzVmU7Q3OVeBtET53NBzRBcYs_fBLw
Message-ID: <CA+EHjTyZx5pU6Qhe8HNw_ciGXDVfasaD6eBnofSfUJk3VnbzTw@mail.gmail.com>
Subject: Re: [PATCH v17 03/24] KVM: x86: Select KVM_GENERIC_PRIVATE_MEM
 directly from KVM_SW_PROTECTED_VM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Jul 2025 at 23:55, Sean Christopherson <seanjc@google.com> wrote:
>
> Now that KVM_SW_PROTECTED_VM doesn't have a hidden dependency on KVM_X86,
> select KVM_GENERIC_PRIVATE_MEM from within KVM_SW_PROTECTED_VM instead of
> conditionally selecting it from KVM_X86.
>
> No functional change intended.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---


Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  arch/x86/kvm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 9895fc3cd901..402ba00fdf45 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -46,7 +46,6 @@ config KVM_X86
>         select HAVE_KVM_PM_NOTIFIER if PM
>         select KVM_GENERIC_HARDWARE_ENABLING
>         select KVM_GENERIC_PRE_FAULT_MEMORY
> -       select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>         select KVM_WERROR if WERROR
>
>  config KVM
> @@ -84,6 +83,7 @@ config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
>         depends on KVM_X86 && X86_64
> +       select KVM_GENERIC_PRIVATE_MEM
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> --
> 2.50.1.552.g942d659e1b-goog
>
