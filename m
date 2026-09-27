Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59CE3A1687
	for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790512692; cv=none; b=JlEv7O/nYWVwJR1c7FEtc6x4yQwe3VZH+kM5rl1Wf1KFs7jNsU20OzigxGo9j6UnOS/my+anGld3mI6iH0XZiSK506U8sZ0X/d5zy+0IjcnmW1NEBN+MjWSx5bPcnbTJyB+9C9K29m2Pq+0I2fb8Od+Fj/6r3eFvUh0gaMOVjE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790512692; c=relaxed/simple;
	bh=NuKsMEW2bmL3HYEzGzn4/Q1vMLgkj5WzRXYhVoZ/eTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B0XQi8mo6JiPM4M+9W4FUeeBwqzsweA+Ri83/3F9zy3LA+etpikrmWIFT5wWLqA9dTS+aCHQZUOLE1yBlw8PVAX7zdv/P0tO9KquZbOBjoQTWZYnjoNESmtfJVaWPgzcZFGqB6AbtReSsdMnvLabyDeduSUoI14SWbk8ksyHKQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YoOy7FYI; arc=none smtp.client-ip=91.218.175.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YoOy7FYI"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=NuKsMEW2bmL3HYEzGzn4/Q1vMLgkj5WzRXYhVoZ/eTE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790512687; v=1; x=1791117487;
 b=YoOy7FYI07NfKhq/rxl+c8ufiWB9B28zFEShCUlnm5Y7nQYNHkw9kZsJr7lIobFgRXspYp7n
 0EcrpMr/wVykj3uZyhMO/VAnkuU1o6IlmIikfEa23q9V09g26IcWWyi3S17EtSANCYAYqk+OP4B
 /wM4Qld+qoUW7E8/+6jn0HGc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d51077b25c52af03;
	Sun, 27 Sep 2026 12:38:07 +0000
X-Mizu-Trace-ID: d51077b25c52af03
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b8e81e2a0bso6240e87.0
        for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 05:38:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByhcEKaGPHotdxouy9oprOQwv4IRKVDfCl5tw0iujGYPdPpPost0OPwnqgCUq21X/1p5IktoAw=@lists.linux.dev
X-Gm-Message-State: AFq9FYKHMi0Gw6KQK7/ZRLRQiXtL7o02d+Q3JWfvPo750QlNKWGWOQar
	2sTCL18jkbv5uL3qY1Uov7rzmIjhadP86jcERYTaFJCQ0YOnjLSzMtrnPcVal7NKnKKX5vQrxtB
	/uYbJIejOKN2i1LmGg9HOywh4ER3yqP2JOuRmgpgP
X-Received: by 2002:a05:6512:b8d:b0:5b6:bcb:26c4 with SMTP id
 2adb3069b0e04-5b8ef285eb3mr99786e87.16.1790512681261; Sun, 27 Sep 2026
 05:38:01 -0700 (PDT)
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
Date: Sun, 27 Sep 2026 13:37:25 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzmGzwhVg=6jkHxzV6LF_WsdR1drobOFNTVWNyB1ZDGiw@mail.gmail.com>
X-Gm-Features: AclHuK83YcLXY0C9NhVVfgcTUZxPrypRPxP9P25GK7wvjm4osxpyz56DMnGRBu4
Message-ID: <CA+EHjTzmGzwhVg=6jkHxzV6LF_WsdR1drobOFNTVWNyB1ZDGiw@mail.gmail.com>
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

On Sun, 27 Sep 2026 09:20:52 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> > and it would be really helpful to discuss it on the list. As you probably
> > know, on Android, pKVM has the semantics you describe above: the ONE_REG
> > calls succeed, but the register state isn't propagated to the guest once
> > it's started running. I think we largely did it this way because we were
> > solving a million problems at once during the initial development and
> > having to pipe-clean VMMs wasn't particularly appealing at the time.
> > It's also worth adding that, to my knowledge, we've never had any issues
> > in Android because of this decision.

That's Android 15 (6.6). Android 16 and 17 reject ONE_REG once a
protected vCPU is finalized, except x0-x3 during one forwarded
hypercall so the VMM can complete it [1]. crosvm has shipped against
that on both.

[...]
> > If it's helpful, we can ask the crosvm developers here if they have
> > opinions for/against the two behaviours?
>
> I guess that'd be useful to know what they'd prefer, and also to look
> into what QEMU does in this case -- I'm not exactly a good judge when
> it comes to UAPI definition... ;-)

QEMU stops syncing registers once it has marked the guest state
protected [2] (bar the virtual counter save/restore on stop/cont), and
the QEMU CCA series sets that flag when the VM starts [3].

On the kernel side, the CCA series rejects a SET_ONE_REG for a realm
outside the GPRs, PC and two configuration registers with -EINVAL, and
lets GET return what its message calls "(stale)" values [4].

Given that, are you ok with v4 keeping the error? :D

Cheers,
/fuad

[1] https://android.googlesource.com/kernel/common/+/cfc696b1fb110
[2] https://gitlab.com/qemu-project/qemu/-/commit/5c3131c392f84c660033d511ec39872d8beb4b1e
[3] https://lore.kernel.org/all/20260903193611.1058589-5-mathieu.poirier@linaro.org/
[4] https://lore.kernel.org/all/20260924160504.853911-23-suzuki.poulose@arm.com/
