Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484E9342514
	for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 10:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791629667; cv=none; b=nTMYaxwYQzL6gLyLXfCi/6vyTc1zHs1RBW/Msc3HFcJt6t0bZDaGIEvTmr8Qm81uLFsJ2X6dC/Pwu3XsbRPsF6VxyFpWq4112u7JKvuBylm3aFfYM91xVz3LNS57YzZZ9fbGYJUnhYQYyyGynQXLOGWpYG5hwQKujRHdUSuRHGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791629667; c=relaxed/simple;
	bh=4W6Za8zSDAqEPJR7i+x9GYTAmuRutHQ2CObwAK+Xt9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=be2TwAAkANfM4lnDK0kVQdmt4tx1U3DFr346bNOqzmU70cef+Er/lLuy0WHb7jHMDTFBRM6wXtEyQbEqUtqqM8saANjaTfjtoTj0bfmEzXy2FYTBq9jnAe8jl+WXyhCCYQNsqxXdhoMVcrzlwj+dhOcr8WGUyqRBZ2+Hul/IUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLJEGubC; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLJEGubC"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-887beafb714so208558b3a.1
        for <kvmarm@lists.linux.dev>; Sat, 10 Oct 2026 03:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791629665; x=1792234465; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=khKL+0SYs5dkK1+NiD4FsLQAnzmLgGQHJt1q1DjIuc8=;
        b=GLJEGubCLWfD83dV6orSgDCy3NLwYFuH8II8SuHdQaAFc9fc8RUv36fBRTWZhXEOBP
         vs/yDqZrVBU2LhIy9A4CmQS0ZpuAcJhgpjeWL9FefLQ9vXIgKPOcY7FX0C3RXadBxpr9
         KVg2FCLIrc/llhzSrye2Ek4+DUgu+xRqCK+v+nP3LBWz+x+6IBHFfWjTl62dHAAlWbUM
         WClP/AhPqonyEf70PBBUeKrZaBmP57yuRCn8+mcsTF5YMUJhs/aX1tyJ/Dbyd1Id1PcZ
         NJkzygRJ9InZMEIr/v7F+z/NfMuoXfbt3piGbYzqEnJIyMsXZUCJtDKSzH/8+sOuQRK2
         RBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791629665; x=1792234465;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=khKL+0SYs5dkK1+NiD4FsLQAnzmLgGQHJt1q1DjIuc8=;
        b=QUM5G3nflziEAhRbCmnxzhvbjPJxVlwob7OZVMNYq/VqJ2n5BUGFThRaZ5NdHfB3Dv
         dPIqNlALUCZk13EnBzcCbY0rMma1Rz0O053moEAFV3hL6FZqIVMJZd7y5Me1rAYFBurP
         B3K/8Le+j6G/s0GghqjXlTabqy6c83tUaD0Kc9DCUwuDfdNs4kr4zAb3XuMFuHemzxGE
         DWY6A1oAiQ1aEbNDu3U1hLvbqHOFOQoDOF0vyihXXB7Uewk07r/plwnSgFEPRARW2Ld6
         11JfVW19b5Hfag9FbNAJN1pVLd9J/0z67JKKIBpKy5aT/oRtoH7PMB6FzsY8zsfBrMxJ
         28eg==
X-Forwarded-Encrypted: i=1; AKwUvBw7xNAd/LdxSziEDzq/vdJKWIc77/MElI8NPbPYJoB0uXG3FvYKX/ELs1u3Y+HAnHrKww64+Zk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLzaOoKFsG4e9ngcbB0flUrZKvZFVrkDMcnGW+6H2kbTTQs/Rxj
	5T+8diTIJ0E8qWiRyiEb0jVryDZqFEKFUmDfmAYsdmY+9QHYya2ExS6P
X-Gm-Gg: AYBFou0nGjhFttDUibsXlrBiqJD5dGy1CaNaJDMPqjz728bOBYJMKt5+0/bE4j8cP1h
	htlixLd9J1PrDNnhdY3+bmu1IlgYJrZT1plL58P5/ZAN94+q8I1TyLAvQlFSUTKrlabHHPoSIbZ
	QJYzPrkBoHaVqptPwZu4nmNdWmIOJ9FnYjAmHp9bMSZYR+QHhy5lbeb1+Lr5qBfrA4aQAIyTw2E
	3a7jNpo5DJl7UlehSup5UDCgQKARZ8hSDP9Ofk8mNszXLI7IR6UveIGLDWc7x9V33i6XDdLrlon
	5tl4ssMbQ4+WqZZRAoSXIdyUwiU/kGG9ncjfUS2VX7wcT3q+jcH/rBzKJi8noDJQvMrvx21X0Am
	TRqvrNITYNvNXsTVVZqM9LZ7PR9tBPhub7IWsj8x+qhtWKLtkXyNslMucu5+c3X3uzYeQj+V6ef
	UBoiKWdviV+gK7aRTYzBqfhO28fcclozwtFs8PBxx2sE3gpqJDlrVfMBHy7vGH5DP6aDXGtojO0
	mqEX9xWnBCcxlVHMQymT5NXqTXJVpy+MR2A1cXhrVa0kg==
X-Received: by 2002:a05:6a21:485:b0:3e0:de4c:71ef with SMTP id adf61e73a8af0-3e16bfcd468mr3602361637.58.1791629665376;
        Sat, 10 Oct 2026 03:54:25 -0700 (PDT)
Received: from macbookair (n114-72-148-25.mit21.act.optusnet.com.au. [114.72.148.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c4996be6sm2203965b3a.58.2026.10.10.03.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 03:54:24 -0700 (PDT)
Date: Sat, 10 Oct 2026 21:54:16 +1100
From: Myria Sarvay <myrialsarvay@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Michael Reeves <michael.reeves077@gmail.com>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Yureka Lilian <yureka@cyberchaos.dev>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Sven Peter <sven@kernel.org>, Janne Grunau <j@jannau.net>,
	Neal Gompa <neal@gompa.dev>, asahi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: Apply existing Apple CPU workarounds to M3
 and M4
Message-ID: <asoZWBEEEsFD5Qrn@macbookair>
References: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
 <20261008-apple-m3-m4-kvm-v1-2-7bb4cbf3d63b@gmail.com>
 <86cxtk2utm.wl-maz@kernel.org>
 <CANpmGNv4uYRLALMLKZn-HJwTiqJO90Fx23DOO7K7d-PfSWn=2w@mail.gmail.com>
 <86bj932ssc.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bj932ssc.wl-maz@kernel.org>

Hi Marc,

(Resending because I forgot to reply all, sorry Marc)

On Fri, Oct 09, 2026 at 09:16:03AM +0100, Marc Zyngier wrote:
> On Fri, 09 Oct 2026 01:03:57 +0100,
> Michael Reeves <michael.reeves077@gmail.com> wrote:
> > 
> > > I can provide the binary (and a few scripts) to test this easily.
> > > Should they have been fixed, we can always create a second
> > > implementation list to cover the PMU.
> > 
> > Can you please send that so we can try? That would be much
> > appreciated, thank you.
> 
> I've sent you (and Yureka) details over IRC. If you need help with
> setting things up, let me know directly.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

I've tested the patches on my M3 Max (t6031-j514c), and without these
patches, it SErrors, and with them (and including the M3/M4 MIDRs in
the has_vgic_v3 list in arch/arm64/kernel/cpufeature.c) it doesn't
SError, and the iso boots correctly to a login getty.

