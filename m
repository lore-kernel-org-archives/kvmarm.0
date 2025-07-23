Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11B21E3DFE
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 15:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753286213; cv=none; b=RJJk/NQxzPjvYNS4jb22uZ1Nd9hQWI+bK2M04IKGLf0qAEM8R7jCk1YYovMltf06An3gv5r6QyyfqUkWactbplFwEsy+wIFz2XwdME9wFAIHpbrOD+eaXv15vb3l3Q+DgAaej4zNEXRW4hIaSBr9f7OLXWHlGRrfsfq1kjvIlec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753286213; c=relaxed/simple;
	bh=Xx2dqPhZid/DVjqgMSquhTFU7ay+TzkkNAEATL+i+gw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nx+2oQFam0dP9s+Y9DWeaOseE1qoe3jvIH6fbhsfHyFXBHg/oCzV0qZhfKg8PRA8NlE9bRgilLfatj/U25BTGD45Oe1uhx/TVhMcq4FSnsJZzPIDZD6wkJg2EXLYeWOM55Xt+6nLEkoMt4F09IM0/NXilIM+PAQaXLvpC7adSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PLAetlwa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PLAetlwa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753286210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx2dqPhZid/DVjqgMSquhTFU7ay+TzkkNAEATL+i+gw=;
	b=PLAetlwaIF7gPljppXI3fSZ/ViAqY0/COZ2KBeqPdblSjvtB+VL2sCQq+BDBquxGAm7TPf
	E884AWOxm2h02MAqk/JWITl+v/BwwnaNsW5vf7oErXrsoGx4PUKcNtlKn+AxJNRDWuQuHI
	RYlay6WJsfwRBRDvsRfrt0b6VR9E5UM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-joACfCZgMFqjvjXcPS1-zg-1; Wed, 23 Jul 2025 11:56:49 -0400
X-MC-Unique: joACfCZgMFqjvjXcPS1-zg-1
X-Mimecast-MFC-AGG-ID: joACfCZgMFqjvjXcPS1-zg_1753286208
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a50816ccc6so475f8f.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 08:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753286208; x=1753891008;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xx2dqPhZid/DVjqgMSquhTFU7ay+TzkkNAEATL+i+gw=;
        b=EnuQx6ZiJWkQx0vl2HKg9Va0b3eFYCz52LVm31GE5viNXdok+VUMUSNZMCAqhcpDlL
         c63FWLpwnoX3xUwURJjOz5ANQn5iKOd4QIoZHVOVERBikAT+rRw4ZetFooELiEikmKgD
         Xts1XnIXh9qCt2pituHfLGSfNOlsIAxeUdt5NgBkvApYDcvqiJXWBVO8Cy/LWIiQm41U
         SFMpikd/sDoJgz013UDWUrCXE40dn/94cLutTkxZ/PUxfzQzZPZKI+oeuX32xU121OXz
         49QcWdcU6uJUIkM9gQIAC2JGdTce3r9O7CBrIYpEmQUadfDCbtxU7+mJy6s4hy0/19u6
         tJaw==
X-Gm-Message-State: AOJu0Yzm2xtfgmI5glX+AE9745v1eQ2+JEE+7+RGMdpoyy2jX4DiQaiq
	ejPESFlNP9ebVJ7ImRTMg//Q/H8iJuhHHvaJDAemqB3RZ2OKYUchGiSg2erj8SpL8oOSM4z5YOp
	4X6DipV/6CHhA2SzxLN0eWtF9VoNtU3WB2lJa934BR+HMmA+vG8O19nCSIg==
X-Gm-Gg: ASbGncumQjud8sKJo8AlxeoQJVouY3pTj7Zm3ed/3RygiA+lJSIeq8Q7jFk0m0MTYmV
	eGRjTSIiXY8yhAiRKZcJwHw9/5+KnWKAoyFv9+Lpu49pYNSn82P8Uzs/7r58ZUBWUKpxie6S8k0
	Y0ZfLV7TcxiETbtqXZ2FnRYNneSTEy/xRQm7+3osysPOxV2fjmW6wAAWpoq/kEzjwQI1KRApc6F
	m2CRifnzk9Uwn0d5MDIfjsz46wEdeRA0/pD2qz03pc/FAZfhDIaCv0MLmJxLwsVivGnoAT3f9E3
	FbQbxfOsa+AQHib0ACWc2lE6lDlrDxo2r2Gc6aPxv7R9EEQMfB9rE1L7GDGiYc08RcpXNR4H4vi
	Vlq0cN/zPiAE8
X-Received: by 2002:a05:6000:26c6:b0:3b6:2f9:42b1 with SMTP id ffacd0b85a97d-3b768eedb05mr3113403f8f.13.1753286207907;
        Wed, 23 Jul 2025 08:56:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRkJqxrVVPLRiwaF5PbaKWf414l/WBiJeIdnuyQV3tqT3YAeHRnT1isf7baSPgjvG55wCY9Q==
X-Received: by 2002:a05:6000:26c6:b0:3b6:2f9:42b1 with SMTP id ffacd0b85a97d-3b768eedb05mr3113379f8f.13.1753286207521;
        Wed, 23 Jul 2025 08:56:47 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4c88dsm16709093f8f.60.2025.07.23.08.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:56:47 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:56:45 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 4/4] KVM: arm64: selftest: vgic-v3: Add basic GICv3 sysreg
 userspace access test
In-Reply-To: <20250718111154.104029-5-maz@kernel.org>
Message-ID: <a6ed6e2e-38a5-41fe-7a63-0418d4ea7661@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zhbjk7zbhq5Zgu56GsO1sUVj-7jaWWxtSNIo-knKhbo_1753286208
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> We have a lot of more or less useful vgic tests, but none of them
> tracks the availability of GICv3 system registers, which is a bit
> annoying.
>
> Add one such test, which covers both EL1 and EL2 registers.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

