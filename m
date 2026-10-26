Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.189
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793023650;
	b=xjQ/N7s0Ae3KB7E6/2WSzb7FESWCdcXP7/6kzAIeCIOHpO5E30jJG1IZ5NbZzNGCHjQ9
	 wmq2Ewx+tuSdRMU+E/6fFKMpJEmhL2OkG2kdFLYIrRx828WuLEdGp7bB5UHWXWl2RxrKU
	 vNwEY0YZ6UjV72/jndNijOhETRGN7/bcrjsNXnex61eKJf+gfCpVZoPP4Eb6ORcBCsOBm
	 V48C0BlLmbMgJ1gjzHqY0MqATYNPvkuRe4sOtxtiNffsLg0jdJs4MMe9KwZjIDFE3klh0
	 QqDSbkD24ZH8eNK8kNVvZTEmGf1NX+VaM7O+u4pZBbcJMdVmWs5iijHUQScPTUvosmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793023650;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=o2NPZbWA6+uMRn4xr5m7DWDGwtChXRj3f2KhhtG1Hlk=;
	b=bKG4txDPejh5V7YIhHn3/uoGmdqzuGWhFL0ELLWD092Uf+E5Y8lzWHP9iItu9Dtm8Ta8
	 ToxZDUcXVIbiyK8t7gcUVedCs6MsR5hmjjPmWuYoij9Fq2Dg+HuOHltKnRXwFcQSiBS8S
	 GcEffO6ZP+ttZOs6Xg1BT99OFMNtvmhpQvjXsS+sGHZ9sT701iqHUxAemF+QbaTJsK94u
	 bzLULHwGb69ZIZ5bk1i7DIt8v/KkDSVPkdVyeIK/goDZ208waeeU+rxBhgC8GpeoZNlDC
	 mpBzI0f203PuwG8A+FmsbLQGJdelgVZMTbQun6aBo64I87ojXLt3PE2a+HRySBaT7lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BOaLcSNb;
	arc=none smtp.remote-ip=91.218.175.189
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B90606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 14:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66B90606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BOaLcSNb
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=o2NPZbWA6+uMRn4xr5m7DWDGwtChXRj3f2KhhtG1Hlk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793023646; v=1; x=1793628446;
 b=BOaLcSNb52fcoWRAcVgWmTObLdGfm77N3xG/4XFYJkJSlpclvOVWQEYEH6gEVdDgOKvfJiB2
 +GDD3F70CDowqqrC3Q6TNASH+zHAMTNvs+G6Oh6i/X+MhSZeVJQ1Kl74FXP5sJ+HxvQA9zJM3en
 eQ/TgBCXXOaytcx17V/c25rw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a5c90954689e6792;
	Mon, 26 Oct 2026 14:07:26 +0000
X-Mizu-Trace-ID: a5c90954689e6792
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be58ad9600so11655e87.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 07:07:25 -0700 (PDT)
X-Gm-Message-State: AFq9FYLofEyueLfmtiQeKHpH5GNHFVVFYFdLEIN63k31Y6NWBj148kvZ
	++jwTKxU4awXtJd1Cec47n9Ec63RcT7uaLlbcGDXk3NmVD+e4rnuaQ0esix5ASJedAH0zYqMRPK
	9CxHPLm7LCLufedHAIpKsO31wPDW1ne6ybZijwWpn
X-Received: by 2002:a05:6512:a94:b0:5b8:f20b:350c with SMTP id
 2adb3069b0e04-5bfb79aed47mr175268e87.3.1793023644976; Mon, 26 Oct 2026
 07:07:24 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261026082305.2515705-1-maz@kernel.org>
In-Reply-To: <20261026082305.2515705-1-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 26 Oct 2026 14:06:48 +0000
X-Gmail-Original-Message-ID: <CA+EHjTwB63+RL=5=kb1jMbbjLa7-r9+L-4xXt28pP8jYjx456w@mail.gmail.com>
X-Gm-Features: AclHuK_Ciqa1-nHCIpB_KeKWlov_S50T8qZTQ8KyurQOAUPRFkCKEJz_GNIaL0Y
Message-ID: <CA+EHjTwB63+RL=5=kb1jMbbjLa7-r9+L-4xXt28pP8jYjx456w@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Reenable MTE on VHE guest exit
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Steffen Eiden <seiden@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 26 Oct 2026 08:23:03 +0000, Marc Zyngier <maz@kernel.org> wrote:
[...]

Tested on QEMU with MTE, on a VHE host with KASAN_HW_TAGS: a debug
print right after the guest run returns shows TCO set without the
series and clear with it. Guests also boot on nVHE and pKVM hosts (as
normal).

For the series:

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>


Cheers,
/fuad
