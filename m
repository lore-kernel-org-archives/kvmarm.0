Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D4B2E0B6D
	for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751305377; cv=none; b=Tam9I/RqMJBG/w67JXBDM0IHsNYP7dw4MEw+/aveUvJTmUi3CA9vKKffYiZb6QOdnm1/NiG9ccV/eHQvGuSTns93kBPyv2xZt50N12oStVZugpbCJcmfWvOky4Qm4Lhp+2L504myIC+OzBZRANlyyc0GcOSSzRPZEOluduNv6cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751305377; c=relaxed/simple;
	bh=p9QHb3/hnKvWZKIXq5Fvg8ndjho6Otu5IGRMFihrTnE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=BxwrFXjDQGDksCh9VHovj3cuz1rkd/NaOeQotptn2mgJsHrs2/ImPclPmVHuHKesWRqJe33W3LzUyinehxWNDehuodTkKC8VqYG039hqQpFVDUs2JisTXAKH5HeICsyori1MaAzdmuCsueHtQUj57kg5ihQLrKxWSQpZzz1NGg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U3CF2jbr; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U3CF2jbr"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddc5137992so26681235ab.2
        for <kvmarm@lists.linux.dev>; Mon, 30 Jun 2025 10:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751305373; x=1751910173; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ImVsekYPJx+C4taW0n4SjIxS/mjgVChiR4QEyhkYP6w=;
        b=U3CF2jbr3riksRJLzyM+h/bApaNLGj0Q2NdT4AbcoMPjf2MPaq3IjjkEB5D4ZL5NFo
         MsOxzBG2kYRo0eCbqCYsLZSL3N8iGA7ktVjGbiSnpUTd4gzlGxAFtCrfDKqNyIQ2pXPn
         88Qp73Mt0A3jMjdUEIyVUcihQ2YoNdeXjmDNh8s3f2OvR6jHa0TIO9aYVtru/SKy16MH
         Gn2oHZiApYr9nyO+4nnkPGeODAp3zo3s87hnJRKrp5w5T6eHABhuzGDDillIMB1Y5aZ5
         +dlo452PeXnBYDLA3zNkzt05SFjX+VBQTeVIRzGJW6EpMWSMwm4duoJv+w7fg3RBcw8K
         Ur8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751305373; x=1751910173;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ImVsekYPJx+C4taW0n4SjIxS/mjgVChiR4QEyhkYP6w=;
        b=YNsg8WBwXaMwEsfV+PYxDgTQRWLEcOCZN46Zx7JphRVQzna3TfbMssFp3Y9HM24ei4
         emWLxOLta7bzP6ZTYNKps43nHP6JhEMUoimGh7qDrcXfF8fRlp9JgXQKDpQRo1jnlTwA
         VN7OU1gWah588627tjCyeRgdnfYwkoOAf38ZFdz6VP3q7YtJLr2uM1Bcxbx8mcqz9Jac
         RNVg7vV3GDbtE9fJIxmUezdBDx1RBg5RWW8eol1GJQp4gumTUwzchR1X0f44Nfy+5Pq+
         hy4lPhEIKd2nsExzD13ZyxFy5+5PVK6aDCNoL+l95DqgYTyTnaf0Beje1F89N7bE6E/M
         JGgw==
X-Forwarded-Encrypted: i=1; AJvYcCWcxyux/ZceMG7qEAjkBuhYhFwRn+1RQ1WrDsjLHmpPzfOmLo8aOjoz0fDCDjCP71Smp+vQOd8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnYTtFtKxCVQHIbf+Mn1a6JUM647aQMl7Bub85IpXxpY/M9EtT
	LgUJa6eUDvEYX2tJKnwVyj51ebfEL9wuGWXF2Xblj4XQEyHMF44YF1JwHkCrJIIRBcTPAsTAQQ3
	6qG0I/hwK3aw0+u+R03gwRqApqg==
X-Google-Smtp-Source: AGHT+IF9nPhO3RxMhccQIRyozfA0RZ1o/n5EUvH0ZvYssIkGUujSgAHo5a6XMuPc/RTrNVL6l8tA4e7hfnuN+vQINg==
X-Received: from ilbbc5.prod.google.com ([2002:a05:6e02:85:b0:3df:2ece:7197])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3c85:b0:3dd:b808:be59 with SMTP id e9e14a558f8ab-3df4acc61ecmr180573955ab.21.1751305372798;
 Mon, 30 Jun 2025 10:42:52 -0700 (PDT)
Date: Mon, 30 Jun 2025 17:42:52 +0000
In-Reply-To: <aF8FPTupC_VnAldN@linux.dev> (message from Oliver Upton on Fri,
 27 Jun 2025 13:55:25 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt4ivx86sj.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v3 02/22] arm64: Generate sign macro for sysreg Enums
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: ben.horgan@arm.com, kvm@vger.kernel.org, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, mizhang@google.com, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	shuah@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Fri, Jun 27, 2025 at 08:45:38PM +0000, Colton Lewis wrote:
>> Hi Ben. Thanks for the review.

>> Ben Horgan <ben.horgan@arm.com> writes:

>> > Hi Colton,

>> > On 6/26/25 21:04, Colton Lewis wrote:
>> > > There's no reason Enums shouldn't be equivalent to UnsignedEnums and
>> > > explicitly specify they are unsigned. This will avoid the annoyance I
>> > > had with HPMN0.
>> > An Enum can be annotated with the field's sign by updating it to
>> > UnsignedEnum or SignedEnum. This is explained in [1].

>> > With this change ID_AA64PFR1_EL1.MTE_frac would be marked as unsigned
>> > when it should really be considered signed.

>> > Enum	43:40	MTE_frac
>> > 	0b0000	ASYNC
>> > 	0b1111	NI
>> > EndEnum

>> Thanks for the explanation. I made this a separate commit because I
>> considered people might object and HPMN0 is already an UnsignedEnum in
>> my previous commit.

>> Do you think it would be a good idea to make plain Enums signed by
>> default or should I just remove this commit from the series?

> It is presumptive to associate a sign with an enumeration. Generally
> speaking, the only fields that can do signed / unsigned comparisons are
> the Feature ID register fields.

> So please drop this and only keep the change for HPMN0.

Done.


> Thanks,
> Oliver

>> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> > > ---
>> > >    arch/arm64/tools/gen-sysreg.awk | 1 +
>> > >    1 file changed, 1 insertion(+)

>> > > diff --git a/arch/arm64/tools/gen-sysreg.awk
>> > > b/arch/arm64/tools/gen-sysreg.awk
>> > > index f2a1732cb1f6..fa21a632d9b7 100755
>> > > --- a/arch/arm64/tools/gen-sysreg.awk
>> > > +++ b/arch/arm64/tools/gen-sysreg.awk
>> > > @@ -308,6 +308,7 @@ $1 == "Enum" && (block_current() == "Sysreg" ||
>> > > block_current() == "SysregFields
>> > >    	parse_bitdef(reg, field, $2)

>> > >    	define_field(reg, field, msb, lsb)
>> > > +	define_field_sign(reg, field, "false")

>> > >    	next
>> > >    }

>> > Thanks,

>> > Ben

>> > [1]
>> >  
>> https://lore.kernel.org/all/20221207-arm64-sysreg-helpers-v4-1-25b6b3fb9d18@kernel.org/
