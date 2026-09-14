Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFF2368D76
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 06:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.214
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789366983; cv=none; b=YUxf7TDgOI3Wazdnbfqo3DbwOobaWVRh7/zETMOWle5oGPImfhoFgPGXAlzVw/bXyK/Riycq7/byazCxXvBYo8aJz0jHGDKfNUoSEJvVzMguAzXAXs3NG3jxsIX8kA2/E/0AHqEHVQL1TxYGxzuvZUttkNUktDuNLbahHPjaDZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789366983; c=relaxed/simple;
	bh=VieHCLikamjyBABp5jihQYyq36aRCo8cSamzhnFC7ic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jLcv4bvo3DJY9/zA5oNQNVNdTsrf5uuQEdM895yEaJszeVcYc1bv28mc8gHGEQubZD1PtlNZmNNjEXmFGZvXRe9seM9dl6iPTxHVIkyjkVAjmfcq/q/QtUcdnyQKBTpaoPcd0ydXDYl+0KbrpWUBmdT5qYS+e4hGW9GbbBpYMMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hM5dqN9F; arc=none smtp.client-ip=91.218.175.214
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hM5dqN9F"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VieHCLikamjyBABp5jihQYyq36aRCo8cSamzhnFC7ic=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789366979; v=1; x=1789971779;
 b=hM5dqN9FM3OVDyz785uPeB0x3cvDDBAVsE9aiFs//2QkikvT8D6Pt3xhoPZ4blEdDS7FTxGd
 0AEffd+uC7g8OyRNCE/lVUFftKVmI7xwTlLf8lXrm7hQXrxfInIyO+dABhljrWygp70WUsUErr4
 EFbnB8kkMxXPpLuIH7LVlA3Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f0877cfbcf92d2fd;
	Mon, 14 Sep 2026 06:22:59 +0000
X-Mizu-Trace-ID: f0877cfbcf92d2fd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so5053e87.0
        for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 23:22:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBykKpztwWmkhX7mjLJTp27qgRmELv6mQ/nsf9tQ2d/D1R40iDQNCQPRuBQTLxZtKn+RwZmQHf0=@lists.linux.dev
X-Gm-Message-State: AFuF++kkReSlQwiFIrZqJ3vTIv4ziMA9kjf5VJRAL7oGpIOZ1MVli2e8
	6XLtXYh2TLBfVpqVhdrv0H0+sgd/v7NFVUA6Zuo0yRMDLTiFFuLgdLmCEz2lIT8Vs0Nqyb3sUHM
	22iNNi/H9GRK11Is+Vb0ie6RL+nCaSFvXhwvsy9rh
X-Received: by 2002:a05:6512:b83:b0:5b4:9dba:7401 with SMTP id
 2adb3069b0e04-5b8af7adabamr12439e87.11.1789366978483; Sun, 13 Sep 2026
 23:22:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
 <20260907070002.3333525-11-fuad.tabba@linux.dev> <aqQA26sBLaOxt5zF@e143914.arm.com>
In-Reply-To: <aqQA26sBLaOxt5zF@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 07:21:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyzoyfWVwi693=KOJnVtfm77WM7xVrK1qohggbXiK+jDA@mail.gmail.com>
X-Gm-Features: AcwNN1UHmJL4XMDsOjIzilf9wFiDj9EFVHlfMzTGCSTBDYYPUYcacTlrGdZ2ZOU
Message-ID: <CA+EHjTyzoyfWVwi693=KOJnVtfm77WM7xVrK1qohggbXiK+jDA@mail.gmail.com>
Subject: Re: [PATCH v2 10/17] KVM: arm64: Prevent host PC adjustments for
 protected vCPUs
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Joey,

[...]

>  For a non-protected vCPU, use PKVM_HOST_STATE_DIRTY to determine
>  whether to update the host vCPU or hyp vCPU.
[...]
> Feel free to not take the rewording, but it helped me understand a bit,
> and felt clearer.

Marc had a second look at this patch and it came out reworked: the
copy selection moved into __kvm_adjust_pc() behind a get/put pair, and
the pinning moved out into its own fix. The pinning paragraph you
reworded is gone from this patch, and the PKVM_HOST_STATE_DIRTY one is
reworded along your lines.

> Not sure here why we use hyp_vcpu->vcpu.kvm over host_vcpu->kvm, in
> non-protected pKVM do we still not trust it?

It was the pointer, not the VM: EL2 wasn't dereferencing a
host-written pointer without pinning what it points at. Moot now, the
host copy is adjusted with its own struct kvm, which the fix pins.

>  /* Loaded protected vCPU: do nothing. */

The else clause went with the rework. The drop is a NULL from the get
helper, with a comment there.

> Acked-by: Joey Gouly <joey.gouly@arm.com>

Thanks! I've left it off v3 since the code you acked has changed under
you, so I'd appreciate a second look there.

Cheers,
/fuad
