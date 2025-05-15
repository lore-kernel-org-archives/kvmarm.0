Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B396218ADE
	for <kvmarm@lists.linux.dev>; Thu, 15 May 2025 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747324562; cv=none; b=ZthQMf0j8uSX+GZkhWwwOoseUM7/63rm8Atw2fpzRypSgVzEVTAaAkp0KYQFkGviq+ZAbjMHCvBjwcjiR8HJhmu2PYHQ5vPSL183niheFPdxQu0f6YFhJ0hkoyeIN73FltRCzeIyue84ltMVXVkypfn74IemZ91xbNysknEj/GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747324562; c=relaxed/simple;
	bh=ZWFaz9G8mCh4fL/ZI8lOzKp4rkTmq+qocrzzt+P6HcY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KgBxo0xla0s0JOOcxIwI20v8mlRhIqTQmBsTsU+9eOdf1b/dG7LVIhQWqrXlIF8ZV/R5BhlRMxYk1+hNQy38h3MKcPbecGB0PtougC9eThOkkVxhTX8ussiVP3jjDbr5wqFY2MXMYv67JRPtq77leEg4ybStS243i/ymWAyUbZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0TL1hgWo; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0TL1hgWo"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-48b7747f881so341411cf.1
        for <kvmarm@lists.linux.dev>; Thu, 15 May 2025 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747324559; x=1747929359; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+K0vt/UsfM3vUNh3n2feDqNw5L/kOjFVTMJKG3X0A0=;
        b=0TL1hgWohB3v0ISnpZadwiuHOzOm2Q62EDKeEPWc5rzHghPni5RAUDL/FFqxyXKcZj
         P6Ws9Fxz/NGX4wqzufdBgdoJPIfK8JFmrUBSJL6fk384yvjErw2Ti9ucqN8wMXta8LbM
         XvL1sHDsEspl2dqviYA88GsHKW00o/WR1BsH+uWSqn794wwm9SypySEOkoZ0X899zssy
         EW8EB+2EmE1B3Ba5on754de/8yEJQzJ9kaSs2y+L4TBJmAjCMiFRFx+jjFwIXb0i39HU
         r1L5iKxTP5m2IksgUnx37o+c4yTgZDaDxsLrbiAJx0lN131P8Q9SsgHfIL9L8nUlXNqj
         u+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747324559; x=1747929359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+K0vt/UsfM3vUNh3n2feDqNw5L/kOjFVTMJKG3X0A0=;
        b=g1j/ZQe2asjNu7ZtpmGuqpSVQ+NdYWhHCz3f6ajgb9JOFTUXpPRQNRZ4eKJ61reJpC
         q+jn105BxXzfh0r4qPtJ0H3Q9z6szLaGwyIgq99YFcWVFQmg66jxyRt4aHLsK78Eh5PX
         jes5JcaroaJhOHqterXY/H1M5jmDhUDkOxsdYo+0jEyYIp0oPgij2TkIGoUtU8kQDZmF
         hBjVUDeQ3QQxSylIv22Iy1LsbV7rdvMC/CIjAO5CxKR3X/LNLeswGa2216MKy7mIbGJS
         czL8h639J3QxtPSHuu5MKi6wasZGRu3TxqpZ57YdgTAJCoN27/GMCX+mKLQ/d3PhN6Pt
         OEIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAny/dAnXOOG2sJ5mLSngjNfcao5qfmThInpbQZE1JY4GnoCx7eYYC0OZ+RE7tP7qHZOqs48A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRqsyb3QpbJNgsXFHwDbt3xZtqKCy36XXpdrZ7TnaDZnd6+WQA
	GKKe1Oxtj9rH4mrq8LBYn9nlY6xRUVTNQC51O33jPRcoou1H7rd4s5S4xPgHMkfT95vIKGv2vu3
	vbkRdLQ8id02gtEfLdp4/srgjovXi0pKHLJVM6Dee
X-Gm-Gg: ASbGncuGUPern598RCzbXgYaCgz5jcHATsV8m8A1S4HBle5divSVRIUMmP/Efm1toR2
	XT/2IgTfY+O+ThceghfIzSgSL0E1vSBt6Do5E8iTH5c0uOYd8Zvku9/5vFkFqYY5TJgqKpEw6j6
	wrC+RlOab+2/VqAXKvu6uvpKHJzBJ4AurPrz8Xq6DZ4kErLBobC9qm3DH/1GI7kSY=
X-Google-Smtp-Source: AGHT+IGE8aOMfceY42fJdDmnr6JiZyRmyYUbEN4lifv+BrH+R9XF5r2WJo81r1w3ZWlb4E8sxeUCVV5r7958jw/lsCE=
X-Received: by 2002:ac8:7f55:0:b0:47d:9e7:91a4 with SMTP id
 d75a77b69052e-494a339e50cmr3395421cf.27.1747324559128; Thu, 15 May 2025
 08:55:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250514192159.1751538-1-rananta@google.com> <5d204cf7-c6a0-455c-8706-753e1fce3777@arm.com>
In-Reply-To: <5d204cf7-c6a0-455c-8706-753e1fce3777@arm.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 15 May 2025 08:55:47 -0700
X-Gm-Features: AX0GCFtGa6LDhgwrs8UTR4zlPfPiOcKTMSK-2-OfwRKhnoGtsBeWQpI8tPkyL4U
Message-ID: <CAJHc60w1rYc9guoideuKpKaukuCyvxu3S7Fidoy3Lh94+_xDiw@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: arm64: Allow vGICv4 configuration per VM
To: Ben Horgan <ben.horgan@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2025 at 3:30=E2=80=AFAM Ben Horgan <ben.horgan@arm.com> wro=
te:
>
> Hi,
>
> On 5/14/25 20:21, Raghavendra Rao Ananta wrote:
> > Hello,
> >
> > When kvm-arm.vgic_v4_enable=3D1, KVM adds support for direct interrupt
> > injection by default to all the VMs in the system, aka GICv4. A
> > shortcoming of the GIC architecture is that there's an absolute limit o=
n
> > the number of vPEs that can be tracked by the ITS. It is possible that
> > an operator is running a mix of VMs on a system, only wanting to provid=
e
> > a specific class of VMs with hardware interrupt injection support.
> >
> > To support this, introduce a GIC attribute, KVM_DEV_ARM_VGIC_CONFIG_GIC=
V4,
> > for the userspace to enable or disable vGICv4 for a given VM.
> >
> > The attribute allows the configuration only when vGICv4 is enabled in K=
VM,
> > else it acts a read-only attribute returning
> > KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE as the value.
> What's the reason for the cmdline enable continuing to be absolute in
> the disable case? I wonder if this is unnecessarily restrictive.
>
> Couldn't KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE be reserved for
> hardware that doesn't support vgic_v4 and if kvm-arm.vgic_v4_enable=3D0,
> or omitted, on supporting hardware then default to
> KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE but allow it to be overridden? I
> don't think this changes the behaviour when your new attribute is not use=
d.

KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE is reserved for the exact
situation that you mentioned (no GICv4 h/w support  or if cmdline is
disabled/omitted).
Regarding defaulting to KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE,
wouldn't it change the existing expectations, i.e., vGICv4 is enabled
if available and set by cmdline?

Thank you.
Raghavendra
