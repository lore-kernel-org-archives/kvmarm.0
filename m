Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83772FE042
	for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.126
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791732461; cv=none; b=L84/2ldqQ+JiJoDslK4B7n2PBvEmbE+lDUUzr5WKWyYGV60ag/Bqdqbf80uEtqtT2dFvluhtcCwBosU7excbyzs7ohPBsCrDSXcl3sO0L4Lcm/egVYv8CWTFv1j/SL4DpAD+CU89te2hCGJd1s+9b36WY1kIQPRv8r6AeqfsNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791732461; c=relaxed/simple;
	bh=suXI9TweIJ9OgvYGDH8vL0MpTp8HpvwFkmEvYZ5Q21c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cSWKyi3zM4npyQjvzh0jM/gY1J6dMqPuxpjLDzFzfNaxGLpw+/+p/ShhOjCWolpA3TPKOcU+7nyDJk80urtjniQKks4tXkzhUycUy4Dgn+RgFHeaSp74w3dWexeTeQ9kxwXUHDYilLY5mvt72VzeNtn80Y9oDUWHh5N5D8xpoQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JulmlrVR; arc=none smtp.client-ip=95.215.58.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JulmlrVR"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=suXI9TweIJ9OgvYGDH8vL0MpTp8HpvwFkmEvYZ5Q21c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791732457; v=1; x=1792337257;
 b=JulmlrVRskf94TsU3SlUtaoD8OycnSbR7hz/wAeujVQGv4IEUmOYMlDYqLJ/fjEaKUM96NXN
 AMbGgYHdjw7+Qub7JofaKM4mWCsQUcAqzGvuwEfpJXy4kuWiDCD9bMmOUxlGtDCH9jCS4qxjf8V
 nK5Hsu0XYhxlg61kr/Y5yuio=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fa0437482b345aaa;
	Sun, 11 Oct 2026 15:27:37 +0000
X-Mizu-Trace-ID: fa0437482b345aaa
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ba40832934so2888e87.1
        for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 08:27:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxvPZFdY2xbWHafhx/oFUAm+mcnoreYN7VlDIXUqhqvBanFThK2iuJ3lUrK7TbLMHoTbFgF95A=@lists.linux.dev
X-Gm-Message-State: AFq9FYLgjfYkcSVgFlMRQ/rAz0T5vOdmNE5rkKFsHeBVmyBk3AKmldlx
	OGshFR7laBWKmqlGkb6OBSVkb2hEHMNNMZ4RRM6PSZdRrZZZt5QQEgNyc38fV802bkxpUuk80PK
	X7ru+iL/RNIvljw15lsu5tnhbVeshVinMUxdZr+qv
X-Received: by 2002:a05:6512:238d:b0:5b8:ebf3:3370 with SMTP id
 2adb3069b0e04-5bce9d8696fmr69006e87.5.1791732452056; Sun, 11 Oct 2026
 08:27:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261011143648.211337-1-fuad.tabba@linux.dev> <20261011143648.211337-5-fuad.tabba@linux.dev>
 <87zewk8e90.wl-maz@kernel.org>
In-Reply-To: <87zewk8e90.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 11 Oct 2026 16:26:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwQzWTQd83ybB7xyhzVZctre0Nn5_Smg8dA7QusNMve3w@mail.gmail.com>
X-Gm-Features: AclHuK_rIOwStTCG2fxSnbJUVb7MyinGSk7pAOJvFzysPaQbzGjG5f9VtEekiws
Message-ID: <CA+EHjTwQzWTQd83ybB7xyhzVZctre0Nn5_Smg8dA7QusNMve3w@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] KVM: arm64: vgic: Do not access the GICv5 CPU
 interface from EL1
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, vdonnefort@google.com, qperret@google.com, 
	Sascha.Bischoff@arm.com, steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 11 Oct 2026 16:10:19 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> This really is perpetuating the wrong model. The rule is simple:
> anything that requires system instructions or system registers cannot
> be accessed from EL1, and therefore GICv2 is the only one that can be
> accessed from EL1. So the whole thing should read:
>
>      return has_vhe() || kvm_vgic_global_state.type == VGIC_V2;

Ack, I'll respin it that way.

> Ultimately, we should static keys for all of the vgic types.

I'll do that as a follow-up once the merge window is over.

Cheers,
/fuad
