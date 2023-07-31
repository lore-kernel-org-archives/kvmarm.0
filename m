Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926BE18B18
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:41:29 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1bbf8cb6143so14785385ad.1
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 10:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690825289; x=1691430089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SmEubc/b5+1ukKHmZiUP8NXK6ZmTPwRGFOIZRTSZ3Gc=;
        b=KsPWb1bI8OHDu6mex8qxqciyU59VHcBE8c/TrFQtscgcFzTfxWbsxZ86iRaaNxYAl+
         uKEGEpPVr5RuACHnIFFoR51eaJEUed2t4e+cwXrQF1OxjVWfGiA2bHAktTjJx/3Kigv1
         aLf1g5txUjo6a56/6JBCnjOVbIAtJXUjDTEeDz/pdOQeXJbHmEsKASOemdZt5AKhHcRJ
         S2YeZdows1O/MtzAgbL+cL7HEWn6oTFY7iHvHMe9wPN+oc+AtA23+j+qV9lSjxcBksWz
         h1pEu0KmsBggaeJ5Qw/klASWUgGhTVJCRwUn+0br0etDmh0uWPcCt7wt/xET1lxd0bfl
         P5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690825289; x=1691430089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmEubc/b5+1ukKHmZiUP8NXK6ZmTPwRGFOIZRTSZ3Gc=;
        b=cTxMuqOZbKUdEnF9UpdRePfOGrfPdGhRWn85N+DfERFG2gJyJPr1hUM0okJbuCQ6U3
         ukRrSKFr5RnS683JQKnsimxJp1Yn9qaBOtkl6ST7AuxV7+NCjR/CP0XY0bhD6rY83Ddi
         n+PoudupFW279XPvbulUbh19u9QDtIzDtaTFkv+thlY1mZ2qe+mfBuPLeTPUknwvM9HE
         SqwV84AKecfTZfwTpG9BNFOPTHG0HonwQ5J28elTHdH0doAdp0p8aoWd8aNO8YVfdVM+
         34w+WjVAUxN5cP9YHSWv5zBgBI4GVSWeG9hhNlGv9QOZtxix4dRQnZtjYsNK9uhaACJn
         W7kQ==
X-Gm-Message-State: ABy/qLb3dwHu00SkqQqtSIVx44/Oz/Lt2H59WJAWgzKMXJs7Uy5ni+Zg
	RN5ysD5kdGtR+o62ZRyOnWROlBo5zHY=
X-Google-Smtp-Source: APBJJlGf7HZFyR3bDyVIouwwAN332PvEDe58O6oPRM2xmpXKj1o/qbd27/Xr8AZ4gMLnHXhphSiN3o4xpSo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74b:b0:1b8:a56e:1dcc with SMTP id
 p11-20020a170902e74b00b001b8a56e1dccmr42348plf.13.1690825288754; Mon, 31 Jul
 2023 10:41:28 -0700 (PDT)
Date: Mon, 31 Jul 2023 10:41:26 -0700
In-Reply-To: <ZMfxYR41K71UV/84@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729004144.1054885-1-seanjc@google.com> <ZMfxYR41K71UV/84@linux.dev>
Message-ID: <ZMfyRnROXNeu4tnS@google.com>
Subject: Re: [PATCH] KVM: Wrap kvm_{gfn,hva}_range.pte in a per-action union
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 31, 2023, Oliver Upton wrote:
> On Fri, Jul 28, 2023 at 05:41:44PM -0700, Sean Christopherson wrote:
> > If this looks good, my thought is to squeeze it into 6.6 so that the MGLRU
> > and guest_memfd() series can build on it.  Or those series could just
> > include it?
> 
> Eh, I'm not a huge fan of having two series independently reposting a
> common base. It can be a bit annoying when the two authors have slightly
> different interpretations on how to improve it...

That suggests that there's something to improve upon ;-)

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index dfbaafbe3a00..f84ef9399aee 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -526,7 +526,7 @@ typedef void (*on_unlock_fn_t)(struct kvm *kvm);
> >  struct kvm_hva_range {
> >  	unsigned long start;
> >  	unsigned long end;
> > -	pte_t pte;
> > +	union kvm_mmu_notifier_arg arg;
> >  	hva_handler_t handler;
> >  	on_lock_fn_t on_lock;
> >  	on_unlock_fn_t on_unlock;
> > @@ -547,6 +547,8 @@ static void kvm_null_fn(void)
> >  }
> >  #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
> >  
> > +static const union kvm_mmu_notifier_arg KVM_NO_ARG;
> > +
> 
> I'm guessing you were trying to keep this short, but it might be nice to
> use MMU_NOTIFIER_ (or similar) as the prefix to make the scope
> immediately obvious.

Yeah, agreed, it's worth the extra line in kvm_mmu_notifier_clear_flush_young().
