Received: from mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846DD3FE37B
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 19:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622091; cv=none; b=MRPS70ErB8I9KJbNXngoGGJ/0zZ0w0ts31Zw+WAiMyXFo15flZ/DpBC1d3Ef4U1D+uIBQUVpFo1+wPuU1p/3lMh7TdKuZTboE+b4lNB9iwwpKMwf87MZNK9wpsLKHUGWP9nCQXa6tlAWTiceb9Mi/PAtIM53hMVRtuVRCANFeaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622091; c=relaxed/simple;
	bh=LoJoWSdVtQQnsqJJIZm/2aBV/AIaM+6m2UreLj3Rv8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=si0mMkGUsUhIfXtKRNfOyIQqX3rAERvVf049RNcjDOZ/SMjlI08TVSa4l853+DgMf2uiMqtQEdCvQqvMpgVbjmXlOcTgueoyHSItnIPZnWmrwKUKd8zdxNiw/Tz/PFqIjP/f37rLZTfCG4VGZcKl9uHEktPGQpsw13OWoQm0iG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JSOmEqcb; arc=none smtp.client-ip=91.218.175.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JSOmEqcb"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LoJoWSdVtQQnsqJJIZm/2aBV/AIaM+6m2UreLj3Rv8o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790622083; v=1; x=1791226883;
 b=JSOmEqcbPFoWnDBos6a1r5yhOdiFTWvcVzNDyqMq6lbe1qf3Jd5uYjfRy6mQCPef5HcKgGt/
 +B+T7acmpLhBTyCa9z1XrrBaH/WhpA7tt9beYJjl0zOBhmqIlVFDTCGwsA7gX2PAKxa/78t5sGR
 /iA2QJ3DzcQL5fvvyWr1MMo4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4aa66393504a70c5;
	Mon, 28 Sep 2026 19:01:23 +0000
X-Mizu-Trace-ID: 4aa66393504a70c5
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b8e81e2a0bso1619e87.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 12:01:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy47/CwJ0Yofrg83RUYc7fbrJlniPGRyG2nK+xPBJtw+4u3RQ9XQFXCTJ5LqVXyKgxXfeOwn9I=@lists.linux.dev
X-Gm-Message-State: AFq9FYIq1RICRY5vzk5LPnjy1nid1yDAxu02oga6Cr7qCgMWUkhlhY3x
	2AjN0Ajs+GVVQxp63fKQ3bhmv3Fqm/B8MHhXphN1BFxaUlsB5xBJoNQdbEqt7lN7JL/vRXE9+MU
	pz3P2jNS56ROBd0h6WOT2FORJT57wmVcTbCZVhlZt
X-Received: by 2002:a05:6512:23aa:b0:5b8:c230:1241 with SMTP id
 2adb3069b0e04-5ba2e786d94mr6222e87.10.1790622078768; Mon, 28 Sep 2026
 12:01:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-16-fuad.tabba@linux.dev>
 <86a4ph5fb9.wl-maz@kernel.org> <CA+EHjTzCQkeXQQcCDwABLR2w+NTmKTG3V6RSmhzYNayaoYXw3g@mail.gmail.com>
 <865x045mke.wl-maz@kernel.org> <aq0628Ci4pfEj0KG@willie-the-truck> <871paf3y1n.wl-maz@kernel.org>
In-Reply-To: <871paf3y1n.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 20:00:42 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw5yJ7PjCkHmg-kuZjdXL2cDa+5StZfiFOVT38FiJCS3g@mail.gmail.com>
X-Gm-Features: AclHuK_A3LGm0XhIK4uWtuZLyyMDjjb433L7Zm1vN8E8cf96YxS-xxb0mI7O9p4
Message-ID: <CA+EHjTw5yJ7PjCkHmg-kuZjdXL2cDa+5StZfiFOVT38FiJCS3g@mail.gmail.com>
Subject: Re: [PATCH v3 15/18] KVM: arm64: Reject host access to protected VM
 private state
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	steven.price@arm.com, vdonnefort@google.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc, Will,

On Sun, 27 Sept 2026 at 09:17, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > > > once the vCPU has run, the copy is the VMM's
> > > > boot state plus what the exit handlers copy out, and the VMM can't
> > > > distinguish them. x0 on MMIO is one of those fields, but the VMM reads
> > > > it from kvm_run->mmio. For LD64B, EL2 would copy the operands out the
> > > > same way and the error could be relaxed to those registers. Loosening
> > > > later breaks nobody. The comment and the message do overstate it by
> > > > calling the copy "not the guest's state", and I'll reword both in v4.
> > > > More on the kvmtool thread [1].
> > >
> > > A protected-aware VMM already knows it cannot obtain the registers.
> >
> > I think you can use that argument both ways: if the VMM knows it cannot
> > obtain the registers, then it's fine to return an error if the VMM does
> > something wrong.
[...]
> > If it's helpful, we can ask the crosvm developers here if they have
> > opinions for/against the two behaviours?
>
> I guess that'd be useful to know what they'd prefer, and also to look
> into what QEMU does in this case -- I'm not exactly a good judge when
> it comes to UAPI definition... ;-)

I asked Frederick Mayle (CC'ed, AVF/pKVM support in crosvm) about what
they think in crosvm. Their preference is an error rather than a
silent failure: an explicit failure is easier to debug, and the
earlier the error surfaces, the easier it is to correlate with the
misbehaviour. Frederick also raised the MMIO case as a concrete risk
of the silent option: a VMM could reasonably think it can complete an
MMIO access with SET_ONE_REG and never find out that it was a no-op.

Cheers,
/fuad
