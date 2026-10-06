Received: from mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8D745563B
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 13:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292772; cv=none; b=V51vNTBpB0VNW3r/K8Nb4jTs1cmUVuLOOCzmnBZb/mRTJ/5nD97ee4VKqgVUO+gYoBRgy2CX6LxB2kpTmu1G/Dhh21Iaz9wFVBCq6qFqT6nhIICBxv1WLbAM7dTtU7Q0sIhH1iRm+HSu7lgb1i2Lwv3iP0lfeHCvgwlx7t1x3yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292772; c=relaxed/simple;
	bh=8qhe/p55ZE1Kz6sMMB02BhuqILnoV4Qe7TICQlsgGOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rMgh2iqMozlgfKROre+Pa7KY6h4omxUwu7uOYyyiMpm5vFDTlVANoyUsIzdl4jhLbeD9ulPAQ+Mdw8bSyebf4ffkC65xkm+sPoZEmsGPxQGTd6Eieo5InqUVIhe2XL35fxpf8VfSvg4PNHdyWQhzlIGvn1uDvEJPI/erdM5dMr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HXIJ8dID; arc=none smtp.client-ip=95.215.58.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HXIJ8dID"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8qhe/p55ZE1Kz6sMMB02BhuqILnoV4Qe7TICQlsgGOQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791292768; v=1; x=1791897568;
 b=HXIJ8dIDsh4HK15XUZV7rIMxt5Ooq6OGJAkZ8EWoHTUKhuPEoOe7cT6m4fpkIOd8SA3ZbRpY
 VefdJSFXKHR3eEyDDv0jWS40C3QhC2QNnIJFnPFgEMPxd4+YTFdqGFMZ3zWFdWWBP2Oz0DGqw6W
 TnLNXCQUhmgujhBGW3BlZHGE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id efcbc698a1ab4c63;
	Tue, 06 Oct 2026 13:19:27 +0000
X-Mizu-Trace-ID: efcbc698a1ab4c63
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so8053e87.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 06:19:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBycCEbKMe9yIukDZZ1MrKyWjGKKvSGXz4zPCfqH0U/phZFCNoQb3yg0FwLe1SZQ7eoRWLyiS7w=@lists.linux.dev
X-Gm-Message-State: AFq9FYIFN2JoBPW8ht5cyaM82kkKRDA5P8zLCDEfgNbUjZWxADHAMoxe
	d0OC1H1ubxuNZLjiIpx7z/u1eJUZ/JwHpZ285zY/FShvWPpDoLNBCDAjKHm+esAO7eyGceUq5O4
	3xVDa3Sn6v/WaY+tMTOmXwXcaOhrTbakA0VsvROyQ
X-Received: by 2002:a05:6512:3f0d:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5bcca857470mr123999e87.8.1791292766315; Tue, 06 Oct 2026
 06:19:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261006092826.2201763-1-fuad.tabba@linux.dev> <asT0g8CcKoXBAmfi@kernel.org>
In-Reply-To: <asT0g8CcKoXBAmfi@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 6 Oct 2026 15:18:49 +0200
X-Gmail-Original-Message-ID: <CA+EHjTzimjyBCPZ-SDzOHWTk1xCAiC4TbA18TeMwiw2324raEA@mail.gmail.com>
X-Gm-Features: AclHuK_KzKWaq2Wxpe7q-nJwzUHg_Ej9eV3dHBV49YDQb3SMjB8JKJGtmUuaTbA
Message-ID: <CA+EHjTzimjyBCPZ-SDzOHWTk1xCAiC4TbA18TeMwiw2324raEA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Mask SErrors in a protected vCPU's host
 copy at first run
To: Oliver Upton <oupton@kernel.org>
Cc: maz@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	vdonnefort@google.com, qperret@google.com, mark.rutland@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Tue, 6 Oct 2026 at 15:15, Oliver Upton <oupton@kernel.org> wrote:
[...]
> > +
> > +             *vcpu_cpsr(vcpu) |= PSR_A_BIT;
> > +             __vcpu_rmw_sys_reg(vcpu, SCTLR2_EL1, &=, ~SCTLR2_EL1_NMEA);
> >       }
>
> Urgh, I hadn't realized that PSTATE.A is still modifiable by userspace
> prior to KVM_RUN. In that case, I would prefer the vcpu_has_nv()
> approach that I had recommended as a backup.

Sure. I'll respin with that.

Cheers,
/fuad

> FWIW, since pVMs do not implement FEAT_SCTLR2 it should not be able to
> write to the register at all.
>
> Thanks,
> Oliver
