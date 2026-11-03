Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713377;
	b=f8uUhUKbMAQL10Giga6/aqV09DJhmNdHAYZ9XDUfCxdV8xfdVJ2PDu0l7mdCxh7Oxz8W
	 0XIEJZDz1QIRryytq+Bt+WP6fv6m3e495tfLQwMc7ujvolDlAC3V6eSFY/8mVTO0zfQbL
	 8DEKFHiXloBRkMG4blYbZ+xV/xvHBPVEsEADTXMWeJk7c9CHIwTxGveb1PTVTs1zTrbGz
	 LhGsLJjKfLMSHBZTfTu6KUeRQG+yZ6XNVKGnB/TBw0a3mkjLQqWDdKLMfzSh7OD0LBmY0
	 nhIqIPJtY7Wj0BxQyXx9e7ieLk5scsIEMaT9Ix1zSyJ2e4iDVZZZuUIIHComkFmiqEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713377;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=XDGk/1b1zaqZV7qJByvDevo3UbcM8JCHCc2CfWtcNfY=;
	b=eLFIAMot2pl3xLjEHTzaBFXnur5lwe0qv7g4b7eK5qa3HEUhskA+InNhM99xFi+p/QSU
	 FC9H2XKT3L8I7FOjHoa7u37rPrrXVx+LtKZxwDKdPXXH6OMxw+T4ow6uW0njss4YHu+61
	 wIrcDc7J4Yh90St5yTtUYH2utk042GNHbo0Nv6L7mFBVXMjZsFdMBR8yHe9BHk19XF1T/
	 kh575PvG2rpt24A3/NymYwxEm7xZlNjfY+rL1EHQdnlwG868Y8hY18vxHq5+fMg8Yug46
	 tWhfD6ih9ItKUGEtEvGIK1VHG9eXjM/JUjBfPcxMwUduVoN3TX575gUo1iWOX/SDaeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RKf4Bfn3;
	arc=none smtp.remote-ip=95.215.58.18
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54098606A327
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54098606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RKf4Bfn3
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XDGk/1b1zaqZV7qJByvDevo3UbcM8JCHCc2CfWtcNfY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793713374; v=1; x=1794318174;
 b=RKf4Bfn3a5TovjZ3tR0IIvMDKoKKDVZXe2nu89Xx9KwZa3DRajm1MPXBCgjgOQVjRqrcv8HO
 PQqMrT0Pb0zyaDqJjDqI5NE3+BT87/p/OVA588hEmNqgJv3ytfMKT2WcTSKgddF13D7Rzc7Acdk
 4xZdEW2R+lGlZ6WiIXW3Je7k=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4ab441c5025a148a;
	Tue, 03 Nov 2026 13:42:54 +0000
X-Mizu-Trace-ID: 4ab441c5025a148a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6634e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 05:42:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBz3E8vD2wZWbcQ4ZDh/2C5YvlIp2ux1CxA6nhw+3L6r05ckVHTSq8NQgjwbbGAN6U491K/3d/o=@lists.linux.dev
X-Gm-Message-State: APuU4Z/0n2gqMvjOWDjDpdEmYx79Y+sgUavzE/qjmCJ59+QhqxIEWYOU
	IxRDs8NIhbSDsSy8KSc7br+u+EQ/pAEPcbLsnAY6IWbsQYrVhCiXi1ThjhLCyRG9EUSYQ2Tme7P
	HAJUrfkBOx2TTdx6oI8VO6YTYGP29pauoYn+B/awD
X-Received: by 2002:a05:6512:2c94:b0:5bf:d10c:ab94 with SMTP id
 2adb3069b0e04-5bff0551cecmr153064e87.11.1793713369309; Tue, 03 Nov 2026
 05:42:49 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-3-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-3-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 13:42:12 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzqNuuwOp3hXnSZw0rFX1vQAn5HZx9UG=DbiH3VAH=K_g@mail.gmail.com>
X-Gm-Features: AclHuK_Rsw6J4kK5YQayTAqwk7a9tn4wa7atO5obFEHkCeocR8wt7l4zy7C7St8
Message-ID: <CA+EHjTzqNuuwOp3hXnSZw0rFX1vQAn5HZx9UG=DbiH3VAH=K_g@mail.gmail.com>
Subject: Re: [PATCH v2 02/16] KVM: arm64: vgic: Pass opaque device pointer to
 ITS MMIO callbacks
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 19:45, Sascha Bischoff <sascha.bischoff@arm.com> wrote:
>
> The ITS MMIO callbacks currently take a struct vgic_its pointer,
> which ties them to the GICv3 ITS. GICv5 needs to use the same MMIO
> dispatch path with a different device structure.
>
> Pass an opaque device pointer to the callbacks and cast it in the
> GICv3 handlers. This does not change GICv3 behaviour.
>
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
