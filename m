Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.74
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713339;
	b=dukOlLfpGRbS9/zyPAXlkYIYCHUr9Y7mI9pyNo92+pahrJ3SD84tD4dWHTpFlUd2isOr
	 bE/RgC6SPkgr6YapODgCu3C1qLJu0uot0gotY9J0e8CtZ2sh5AzFxEDaevtGnSO5aiLuI
	 rW/pH01buDA2dQhJgDFpio6OqXNDQovNSHB/82QqXc2gqCgxk01yKoYrtdNvtGAmJtc9y
	 f+P2hfH/nd8mbgAQWbA+5i9tEJVXdzuuEZWqy+F9CiCOiP7OOomewejHHQGR6jnH8646G
	 712cnnUwlDnMVSfj7MXZc/dI3z/QYC+hzrpDtKrzyUhzquGwqDafD8OrBIIsHXEurNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713339;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Q9qnXfHVWDfmE9hIzIuxQlA5TNXMmk+3sfayKRD7PX0=;
	b=fBVgJjf9hWen2kjjbXRQ4q3qqZUA5FsyHrTEVNiJue0YoY5K2voNrWQ95HVEQe5NxiIj
	 rwTFE4DRlL1KflCFNV9y7bQSAQnknCZCjQAyfzIq+SFx/kQVd9qcuaUnSfm7kmqsUvzdi
	 NjVPVNidCDBth0pMTEs3QHBXXlupwqzD9PDpprp+TRaz5k0rE7irtJTpm9Qpd0HlmC3E1
	 N+sNrsXnDFCziW2toWctDK9nESdpjdSa+E81EHue4j61WEIGYcPuWQFyT10XxpayXPPdd
	 xae8FF4Fb3dRsK2Ql9gtYR3VfXbaqIpMlsvcoI1jnUvAnQS3ovnvh5dsDYVqEgn8Fsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QhFVG7n4;
	arc=none smtp.remote-ip=91.218.175.74
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85E6606A32D
	for <kvmarm@lists.linux.dev>; Tue,  3 Nov 2026 13:42:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B85E6606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QhFVG7n4
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Q9qnXfHVWDfmE9hIzIuxQlA5TNXMmk+3sfayKRD7PX0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793713335; v=1; x=1794318135;
 b=QhFVG7n4JlXWQN1VL01GaON0fW/Fofa38zxWbKQmOB3NsUYaYaB6W9b0VQUCJIGD8z/6fkEQ
 FFuZiW7c9nHHnJ91o/B4PaUO1eXKZcMQtU46JrTE42Vcejph3a15s2AdiowYzOpGf+gddKSmbod
 u9VK9XPIMaURRBVsUpZB8r+g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d8715846f51dadc9;
	Tue, 03 Nov 2026 13:42:15 +0000
X-Mizu-Trace-ID: d8715846f51dadc9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6618e87.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Nov 2026 05:42:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBx+fYO94y2Bf3SZiyiTEns17MOADzBQcm06vDX+vLWGelcrsyHfYwcW0uhvBIWhUNO2zc/AkRY=@lists.linux.dev
X-Gm-Message-State: APuU4Z9hyEZ41p6/bDjG/v+jGI8usYUclWH9Yp6Z1DuZctCqV7gzdp7x
	03gawnz65T27z0Ks4kND4Kp640ph05PAMhCZrwVABXJ86Abpi6Yp2bFOefsAdVUfUvp+/gQeSlS
	Gnpj9y8NxcLlqt4cvcQoRYFQE6hu1w0w2p+SReUK0
X-Received: by 2002:ac2:5385:0:b0:5bf:f060:c0f3 with SMTP id
 2adb3069b0e04-5bff060c331mr94794e87.12.1793713330954; Tue, 03 Nov 2026
 05:42:10 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102194454.4086911-1-sascha.bischoff@arm.com> <20261102194454.4086911-2-sascha.bischoff@arm.com>
In-Reply-To: <20261102194454.4086911-2-sascha.bischoff@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 3 Nov 2026 13:41:34 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzKKG-F4aCRiCQsJOspZJWgKA6PjVasEcf_qP7W7H_Z_A@mail.gmail.com>
X-Gm-Features: AclHuK-eWl8epl3U-D4A5JlaL5YUw0LbIVdH55Fk5BPVD-YR5A-BnAm0yAolBPA
Message-ID: <CA+EHjTzKKG-F4aCRiCQsJOspZJWgKA6PjVasEcf_qP7W7H_Z_A@mail.gmail.com>
Subject: Re: [PATCH v2 01/16] KVM: arm64: vgic: Split out common LPI allocation
To: Sascha Bischoff <sascha.bischoff@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	peter.maydell@linaro.org, lpieralisi@kernel.org, timothy.hayes@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Sascha,

On Mon, 02 Nov 2026 19:44:39 +0000, Sascha Bischoff
<sascha.bischoff@arm.com> wrote:
[...]
> Initialise LPIs as Group 1 before publishing them in lpi_xa. GICv3
> LPIs are Group 1, and another vCPU can find a new LPI as soon as it is
> published. GICv5 does not use the group field.

Two nits: the old vgic_add_lpi() already set the group before
publishing. The comments in its_free_ite() and vgic_alloc_lpi() still
name vgic_add_lpi() for the GICv3 path.

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Thanks!
/fuad
