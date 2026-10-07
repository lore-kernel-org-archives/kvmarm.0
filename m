Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E04E3B2FD9
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 10:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791370373; cv=none; b=c8zvvj96u9cgm1UuBS5Ix9d10PIJlV+PMc6lHVg3Fdumae9LEEl6fV+sGnjJGfJBNWFp2lHTgTPhLyDCpAG14r40/9RRlHKItDrI5lofAKenlAKVQOZ3lzmKDa5tI2sWdFpkv8VvIkZMt8Do9QstKWHWVeCjdhWIVw17lEfjALU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791370373; c=relaxed/simple;
	bh=IYj7GJMoI4iyh7cvdiMZ7m7A/3iJ5WzI14Ui9Zh8zRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dzy6djatv4DG7RKOX76Zlun+ENmket4edb8HsF2NaYc4YgFVyk5ruQLgKADv6OrqjYyGdZjteyw9cSeRYnKsoVfJAJLzQ3lDCvGKw+2ZXqn899cVJHv1YfdkpNF3yi32SMgn5G0IGA9FiZ73lWdljK0XEC5QUzvx3xH51ZVK60c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ww8Rt6AZ; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ww8Rt6AZ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=IYj7GJMoI4iyh7cvdiMZ7m7A/3iJ5WzI14Ui9Zh8zRE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791370339; v=1; x=1791975139;
 b=Ww8Rt6AZbPM6UbYQlVrmZVWN0sSCDD1/0jCSTHZkN671Vhc5hWsiZGnah45u7V7QB8/YGTX0
 qDYLhh6xiogOLI+ZPrdycW7NiBvd19xZ97x8D/Us0oEpV+P9i/V5mFiJ22uHHVhlxno+q06KGC+
 QNTenZ4bxcClcYH1itzVya0A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a6734718324885c1;
	Wed, 07 Oct 2026 10:52:19 +0000
X-Mizu-Trace-ID: a6734718324885c1
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so7431e87.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Oct 2026 03:52:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwycsv5G6plc6ITz77crmI2F/42Hakaqpj9aM08jAbNnqN2zGesQCmCcKVtp+XKtES8VR0N22I=@lists.linux.dev
X-Gm-Message-State: AFq9FYJCfVjPa+ziHW/H2FEEbbmLWOz/lbTokFxKPWYoU2gBvzLJeJMP
	B5N2iUBeBN97l13gNHf8TqyszCFinZxYayhcBoeOXU+75joyO9Rjuse13DqpDtt5Vcrgj+fN+Tu
	NfD3nvMd9fkP7a2pBxQftJPoUFKpyX9Vza1DH5vDc
X-Received: by 2002:a05:6512:a89:b0:5b8:f20b:350c with SMTP id
 2adb3069b0e04-5bcca123ca8mr312158e87.3.1791370334717; Wed, 07 Oct 2026
 03:52:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261007073537.2454351-1-suzuki.poulose@arm.com> <20261007073537.2454351-3-suzuki.poulose@arm.com>
In-Reply-To: <20261007073537.2454351-3-suzuki.poulose@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 7 Oct 2026 12:51:38 +0200
X-Gmail-Original-Message-ID: <CA+EHjTyb3-QoLa6P-dGXVdMh9E_vO3p8HceH3TH8h8gPJSd1Kw@mail.gmail.com>
X-Gm-Features: AclHuK9KvLpSDQrj6i2mZweuyXItR2scaGR6GbHNtuuSCxJB5qE1qI3r7GdrQYA
Message-ID: <CA+EHjTyb3-QoLa6P-dGXVdMh9E_vO3p8HceH3TH8h8gPJSd1Kw@mail.gmail.com>
Subject: Re: [PATCH v23 02/14] KVM: arm64: Disable Steal time accounting for
 protected guests
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 09:35, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take into
> account the kvm instance. Even with that, a VMM could skip the CAP check
> and proceed to configure the PVTIME as we don't do further check on the
> DEVICE_CTRL. Tighten this up by passing the KVM instance around wherever
> possible and catch things early.
>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Someone beat you to it. This is already in kvmarm/next as a5b0f36a045e :)

Cheers,
/fuad
