Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D03248F57
	for <kvmarm@lists.linux.dev>; Sat, 24 Jan 2026 07:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769240998; cv=none; b=Snai72Tq8mDx3YB+iNDbHLOZJL8wxHIO1bT658NIvdR+f/9QFM9j8M8m0BEcQyXzK6PrFv5K5rAAjHCjzqI2vVbblrdW1PSo4QHSnXcLaXGExt83tGkHPIrnWCJlV5FWOlfyfmaHfpRy1P+4WcDlQr0dXiLx4YDxSduzX6/4Qpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769240998; c=relaxed/simple;
	bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FAbG3UzQJ8Ko+fVPuuU+rwxLi3nGXla3yVloqow2roUUFeTf1IKGpQE/9eIoD6+JjHU2BIOX8AAYSeItPq/P0QgunS13M3jOF2fkG8bUgn+6uCoFmVYaBWqFmzc/U+95ZaiVX5DM++72iROFKknVhVMW8b7BgwziGv4KHqJ5Jwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ok97up28; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ok97up28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769240995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
	b=Ok97up28cwKzKuP+BwTkQqyLnQji+fmpvR+421Kl1UxREhVEKI9QEBXxtxoyxEmcNL6x5W
	VBHafoFohNpvP8u0TuMEbo+EUR1MbW51qu3rsO3KWYS3q/QHW8ldsLzrDbFtkuI/vg+6ul
	jW7c5S/bM2edBn7xKeUJ/A5MZLLw06g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-D7bX__SpM76-nKZd2Pr0cA-1; Sat, 24 Jan 2026 02:49:53 -0500
X-MC-Unique: D7bX__SpM76-nKZd2Pr0cA-1
X-Mimecast-MFC-AGG-ID: D7bX__SpM76-nKZd2Pr0cA_1769240993
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435af2d3144so544296f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 23:49:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769240993; x=1769845793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wjMnGoeDh+YdrtLg+xDqC4Hnv8XghUga4m38t6BAP9M=;
        b=HQmYlJKHpxb+CSakJUFuld4o+QldUwXOColTGbtzBthwQwB7bkROwac6fkkD0G9idE
         8tRGkLkLRNcdwYm5kP8nBnqdbhJ+Wt3lfQOFn36OK8lAwXAUGycrDG91WKBUu1NRpcVT
         WIuCfIA5P8lIvJgf+mhj2jUIoC1AxwAYcexxoWGwQhNhQqlKINGfYtfTwC54MrauiJLa
         xA5sOxuqHi6klPIyEs0SS1TxArfMrLOOYCTCq8a6+iw40SeS3C5GHTlLTgNO4reSY2QP
         w05eLRaVfBGbMMSYP42UM0/ZhY4sNZZRevvBnOlC59qfdYlnudiqP/TtJAhdmwrCMTv6
         ucDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXi9MBcUQ8TC/gIvifHxeZlVkQb1aAv3g+ZXF7JH9Wu2zqPOCPhxptmdZg/dy1DJIYb5AxAWkM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBHFuXgL+PHVJNNfoDYzj0Ohy7lVh6TiJmtccGGg6hszkP40Og
	zoNWhIcmixhrRVbigjaX316QXO7AXrG0KuxeqxL0WJHxuX0OcFkLnsAcSIeNljIryy7UCyPQFY6
	gS98wfqQSbuiBjQ9JaDcSoo5itair4JqaMxn9b/Qjx0cAcK2kZRG0rVO29adu6/skYNgwke97gU
	qU3xfUndM7yHFbV1CUadd3TWjo7Bgh2cyX
X-Gm-Gg: AZuq6aIbJCDwOfNH7JEVw56zQngBmQqR8Bwjj+Etc+TblE8Gc/XsBN/ZpnBqDCQfS76
	qrky7ZbDKsgybeDwlweAIJPXWUxVRzQzOeEMWINjv2uGa1rWWnoDkkTtv/Ks5Tf7k2xbgJ8bxhA
	YAUAFgNYlqLETUlHkjRUFy8BXlDRS+hFtJueKehS0TCPOEaf+UViGcitAohlE0KVDpjFD+But2+
	oI6aDMRtiTKabfF0UO1kPonTkVqVnmlWi6vd4rSLHr4Wixr6Z+mMnh1/FU5v2k1fDzWLQ==
X-Received: by 2002:a05:6000:601:b0:430:fdc8:8bbd with SMTP id ffacd0b85a97d-435b16039damr9146802f8f.41.1769240992690;
        Fri, 23 Jan 2026 23:49:52 -0800 (PST)
X-Received: by 2002:a05:6000:601:b0:430:fdc8:8bbd with SMTP id
 ffacd0b85a97d-435b16039damr9146785f8f.41.1769240992303; Fri, 23 Jan 2026
 23:49:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com> <874iovu742.ffs@tglx>
 <87pl7jsrdg.ffs@tglx> <5bea843b-dec8-4f15-bb7c-1d0550542034@redhat.com> <87sebxtrgp.ffs@tglx>
In-Reply-To: <87sebxtrgp.ffs@tglx>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 24 Jan 2026 08:49:40 +0100
X-Gm-Features: AZwV_Qj6aLwVSas8vwNUo-Ndu2FBevRcUQp0THPxC18GLGDTRk3JARciXPkQtdQ
Message-ID: <CABgObfbijO2k6fe6z03M3u--4ZKXxwPSf2RrasU1=J5rtj9CUg@mail.gmail.com>
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
To: Thomas Gleixner <tglx@kernel.org>
Cc: Ankit Soni <Ankit.Soni@amd.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>, 
	Naveen Rao <Naveen.Rao@amd.com>, Crystal Wood <crwood@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FZXCkShQv0zc6hMyRsCZi6OqP5lX30iHl5ZJwSWH1AU_1769240993
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 7:47=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> On Wed, Jan 21 2026 at 19:13, Paolo Bonzini wrote:
> > On 1/8/26 22:53, Thomas Gleixner wrote:
> >> Are you still claiming that this is a kernel/irq bug?
> >
> > Not really, I did say I'd like to treat it as a kernel/irq bug...
> > but certainly didn't have hopes high enough to "claim" that.
> > I do think that it's ugly to have locks that are internal,
> > non-leaf and held around callbacks; but people smarter than
> > me have thought about it and you can't call it a bug anyway.
>
> Deep core code has a tendency to be ugly. But if it makes your life
> easier, then these wakeups can be delayed via an irq_work to be outside
> of the lock. That needs some life-time issues to be addressed, but
> should be doable.

Thanks for the suggestion---hopefully it's not needed at all and we
can delay taking the lock in KVM.

Paolo

