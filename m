Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B835E3E9C1C
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 19:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788462856; cv=none; b=aCa5MDFZiXY8mXbCsEKCqelrMsF7RdBxWFVdjMJhM1k0hFoTI5/vwiWv6JgD5wIHaU139lqDd62NEJWfJ4uqhIrksQCVMYoqKfgc1ov5XYNUXXV+s+dVAjj01kaXY7uraNtrGJ/Q4whrKswwt6hhLpzn0lMQH6fGbOpa93yz0CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788462856; c=relaxed/simple;
	bh=LQ5MmxlCmAkfvdFvXrKZhXx7Fex14wUm+MceK68pFDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ji1iqh/73453w+cfjet2FuK1f3t1XyMxwoRUJsmDQuGb4Mofw+KmGsUNrBxX9mqs9Ta7RZwgYu4vKW15OonbnF2DrJZVGX+d9Ie4LbgSliE/pcnnzAGbMZUKpv/pSlkM+LE4tvw9aIDYTVoifGlXBMCj5H/sTIZ9mOesXBZwukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cwdSFHGU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cwdSFHGU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788462825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ftgzyujbx9F68uHjOCU1/tri9c4N8S6xaXNJtzq3Flg=;
	b=cwdSFHGUB5A4gw2DrXzNUj8QNSk5NRzKQXNlNBKl5gcyW8AbIIsQ3VXAg8cy9jZEkGboev
	VknJLN50cEM5kARqRg1jo4r1mWl/2NBSuDGwQxOClWnRO3NdwiFK8kvJm5GYS7U6Pqm3C6
	7FyygcPNYD+HUEUocketHZue9RCBi+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-Ci5aLwJBM6K7wyOTZjdNfg-1; Thu, 03 Sep 2026 15:13:43 -0400
X-MC-Unique: Ci5aLwJBM6K7wyOTZjdNfg-1
X-Mimecast-MFC-AGG-ID: Ci5aLwJBM6K7wyOTZjdNfg_1788462822
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f6d70223dso144531f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 12:13:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788462822; x=1789067622;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ftgzyujbx9F68uHjOCU1/tri9c4N8S6xaXNJtzq3Flg=;
        b=e4tdPy8FlT7KU/Yzt2aLcjiEm3lSbn1pwlof3pMjFEET3pKDFBNuzrq8SX1B4z58nr
         JzrrX3AT64P1bm+rX96z2D86PC3cuY89v1FsYt87aPHPC7GDcgUavhel9Z+0b42gl1ZA
         lAHXb+O5ba29YIUr4dw17kaG7uTiCZi8KI6fVV5bhX4eRtNmiim64SIRXMvYQvCqAXEp
         2u1QcTtNxbfgb4EqJRhlgt2dj0Yp9/VHxGsMLH/Tr7Iq5IxQtLyXOaZJvrcfPCr2NxM6
         63omfnP2jEIZDCWANaKpGDBOYjfGpB/Z9esNtSTHs0IDVfzA8vZ9BTx9vaIg9n3mZKeX
         JOmQ==
X-Forwarded-Encrypted: i=1; AKwUvBxO1FrpZeTmpH/JQ/e7ZEZYy8jHHMflC59MoXE1+IFKk3KnD1kCTvmKmbl/tw4n/UkiD+ZTLGo=@lists.linux.dev
X-Gm-Message-State: AFuF++kL+aVqBb4Kmhj5UTcOmIWeSr8cfSgI20h+7CviXjMiEehip8d2
	S2ZDoGbdULw0+XHghZeq6I/GxrsSaAEtW5c3hRdKgO28WSY1l2b7dcaKQzy5uhJOjxM0q+sMUC0
	EnOJyVu4Okm8L5IiU8SLQ3AbFa4qvngF5wc4lnJy/qPqM9C38VtAj+E+OB7fMNIhb70e+ZoZlbR
	0SiNUHWhmTcpfvaOUN/omXJ1kFbaqQqQYh
X-Gm-Gg: AYBFou1H/f1JHU+XiQmBGxrDA/9WDFuIRg319I0wdQNwj6koz9zyEzITWyjZpUrOa8/
	gvsQdaWRee8vz413ndUOUf9OREdKdjQmcUOr8KiDYtmFMGe5Wvz2yPN00a7bsM9peMmurRN8uHn
	P3Z1lolMLZei3Ymusu+0KjPyMg0FsvbJbcLLGbVGCy0QwOD4uXG2AZv6Mp8JWIPx3vySKr8SlH4
	CQfaz/3oBcvmvmKErNI8zLwRO8vC4KmMmPlGmnE8Ubl/CUHASNomfsiSi8u
X-Received: by 2002:a05:6000:2084:b0:482:f0ee:1390 with SMTP id ffacd0b85a97d-48587289c5bmr2438696f8f.22.1788462822435;
        Thu, 03 Sep 2026 12:13:42 -0700 (PDT)
X-Received: by 2002:a05:6000:2084:b0:482:f0ee:1390 with SMTP id
 ffacd0b85a97d-48587289c5bmr2438609f8f.22.1788462821985; Thu, 03 Sep 2026
 12:13:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-3-seiden@linux.ibm.com>
 <apdweRfqt4dTxcU9@google.com> <20260902075028.231001-D-seiden@linux.ibm.com>
 <aphLXQL1H2zYZgTi@google.com> <20260903114241.33034-C-seiden@linux.ibm.com>
 <apmEi1NmOUvmUBFP@google.com> <apmFClPZ2WcDINmT@google.com>
 <apmIGgMEN8w-kQAm@google.com> <19d4feb1-d703-4c62-8622-a6d5e9d6394c@redhat.com>
 <apmYPMMPCNzK9ZEA@google.com>
In-Reply-To: <apmYPMMPCNzK9ZEA@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 3 Sep 2026 21:13:28 +0200
X-Gm-Features: AcwNN1VM-0Sta_usKYpoIMa4PlVb-9vByCd46nQw98qW4Zt-Pg_0xPWbP_VjwBM
Message-ID: <CABgObfZL-qNSaNkNZDj0Kk41zw6UZ30vkSxc6T8wb-pOKab9Wg@mail.gmail.com>
Subject: Re: [PATCH v7 02/23] KVM: Make device name configurable
To: Sean Christopherson <seanjc@google.com>
Cc: Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
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
	Suzuki K Poulose <suzuki.poulose@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: A0JOgjD75QNFX97eAuVr3fi4-89XNMrUnZPDssg8m3w_1788462822
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 5:54=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Sep 03, 2026, Paolo Bonzini wrote:
> > On 9/3/26 16:45, Sean Christopherson wrote:
> > > > > Actually, thinking about this more, what I've proposed here, plus=
 the pattern of
> > > > > #define-ing macros in arch-specific kvm_host.h files, should suff=
ice.  For things
> > > > > like __KVM_HAVE_ARCH_VM_FREE, it absolutely makes sense to #defin=
e the macro in
> > > > > kvm_host.h since it's very directly tied to an arch callback.  Wh=
ereas with KVM_MIO
> > > > > and KVM_ASYNC_PF, because they enable compilation of C files, it =
makes sense to
> > > > > define them in Makefiles.
> > Ugh, defining CONFIG symbols in Makefiles sucks.
>
> Sure, but IMO wrapping entire files in an #ifdef that comes from an arch =
header
> sucks more.  And technically, these aren't CONFIG symbols.

True it wouldn't be -DCONFIG_ (fortunately). But even if technically
correct is the best kind of correct...

> > I don't want KVM to be the. one that does things differently *once more=
*.
>
> Too late :-D
>
> arch/arm64/kvm/hyp/nvhe/Makefile:ccflags-y :=3D -D__KVM_NVHE_HYPERVISOR__=
 -D__DISABLE_EXPORTS -D__DISABLE_TRACE_MMIO__
> arch/arm64/kvm/hyp/vhe/Makefile:ccflags-y :=3D -D__KVM_VHE_HYPERVISOR__

Sure, VHE/nVHE is fair game because the nVHE case is in the same boat
as vDSO, arch/*/boot, and so on.

Looking at a grep for (cflags|CFLAGS).*\-D most are -DDEBUG,
-DDISABLE_BRANCH_PROFILING, -DDEFAULT_SYMBOL_NAMESPACE, etc. and in
most cases they seem like a bad idea. Don't do it for KVM please;
requiring -D for all architectures and for random pieces of config,
when you can put it in asm/kvm_host.h, is just as bad if not worse.

Paolo

> And I think there's value in deliberately being different, because CONFIG=
s are
> kernel-wide things, whereas the thingies in question are KVM-local macros=
.  I.e.
> IMO, having the behavior stand out is a good thing.
>
> > I'd prefer to stub out the contents of the .c files instead.
>

