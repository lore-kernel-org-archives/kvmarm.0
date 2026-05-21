Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6972F1FF4
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779373368; cv=none; b=cCoraMZsIs5cLjrcUsIIZCgrLPWZVyGojcCMrY0mA+FArBBZI5H8uRuebGX0uEgJUtJSdvvfvWiipJhSUdTgNXAmHICD8z7k/N7pQrg5bncFWfDjou9Ck6UO9D3CnrdnrCVa4woy7Yi4Dg2QEDxIkXKNEacaQIMzlOqptnpU80A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779373368; c=relaxed/simple;
	bh=RH05gHQfsO6XxElUEre8MjkhjJLcn3LTyidfBnh+DVI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gpNfS+w2UxwApPKmwTuc2DLZXryHTvVPRRnuYB8PaCT7/rsdzsItg7zXa+XAPLuKexdWWGlUPb00QJZXEKcaNhK6DF3AXt+Pn9o4o39ihpANhXE+G7YH0NdfBUoOCV15EdYWweDZWlcDMSsJr/vX2xM4w8sDRtRI2Dln6fU+3Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vfghgbi3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vfghgbi3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779373365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RH05gHQfsO6XxElUEre8MjkhjJLcn3LTyidfBnh+DVI=;
	b=Vfghgbi34twv3+CeUb8fjKtGo84rCLuTXubn8NFxi9Fmc8g6ABzVmhal36LIYglHT21ov3
	i8dDURpPkt0w6zQlg5+ldmCReLDjFMRO9uJyEIIC+DI/+Hegfwul6CsnBQ+LMKzrm8c4iL
	j94hbji71oYNUVZFL6/TxNXpyUmBd24=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-4MSRR1qqMJqpHQgfcO-WeQ-1; Thu, 21 May 2026 10:22:41 -0400
X-MC-Unique: 4MSRR1qqMJqpHQgfcO-WeQ-1
X-Mimecast-MFC-AGG-ID: 4MSRR1qqMJqpHQgfcO-WeQ_1779373360
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44696b11265so8136780f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:22:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779373360; x=1779978160;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RH05gHQfsO6XxElUEre8MjkhjJLcn3LTyidfBnh+DVI=;
        b=HXuhD5zHs9oRmb423MjKYNxE21ElCvSk4/dbw1bu55yLFsvs1db1tLhNyFQJqj9NbY
         VJDwJBfHKJ9ep6jjjLKW8GJzVyEoWAXa0mpNmF0MPn/qGp6krlXO3kAWZi9tFQrLIGWt
         ksRPWP1MUSXLd9JdpHQBHZj06VMjRYe0VB7OobSU5vaJPUoQxue+na0anKgJpcZhrc6b
         HZsuxuhYzsGkOadicE1uv4WkEx1ojr7s/9f1geXCZ/PssyYUnf6QmATNQjKf7bLb0uQ2
         nksUHBNPzF+YS+U9v1U7Cd+nafKwBmNyX5eTpZqBZZbXIzJQEBDmhCcToJeV+PB9yt5+
         ANqg==
X-Forwarded-Encrypted: i=1; AFNElJ8lPJ27fq+sEWr5LBtjeYkRCcg5hB35gZN/CiHLJTnrhFD3SXpSg1YNC+M0tnvtpysiCNzJZtQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJr1cQ0X5Th0uLu4xAQ0dy2LMUM2c07Li8XS3z1jBzuIkn1uzW
	iiqe4i7Tn7MB8TeThYupyw9PNCZX4hOquDI7ADhdmOTc+xt1lF1o2H7ghtH1bzRBdBUjdmOKrlB
	AD9qZzWdiN4cHsDQ/7jP5u2KjQkT1zLedgN1N0+jpZksYP3qRiGeniiTJpg==
X-Gm-Gg: Acq92OHDc1rxOkZ7s6y1Jm+ox7vQPs8NniIN5yftjEkegUWfoKyuwXDUvYO99JI+cjd
	F1WPNDx8heJxJeWdr8tEaY1HRBG4fVUJw0HOs66rDj+6FB0mBUwcefR8T7gZGuca0K9CwVHMb7d
	hzZN6jycI+UBjXjO6IY9X7RCfRXNuEkMJgLKpv3g6ekLGaVgDyGl0Sx4WSWOZRDAugwZAwUSX5Q
	KyE7xb/hyQmbJ70qc9h2DFCZV9Hu2w1T0bSWzxU6J2blDPP3TPonKnqYMeaAbND5tG1OXILqT9m
	iL6sWjBsllkm04q2Ng0uKPxcyZ/zM/R4TIFB2GZkvuYoGzXFRGwCCvXnqKDO2rF0eKKNSMxhBlI
	JPaTDLKci3KwrfZsLVw0yqeba0ZJhnLW+hte5rHlU82NJwC7UP/HWH1Onmq9k+H1jpd7hvSs=
X-Received: by 2002:a05:600c:1c0d:b0:48f:fe2a:107b with SMTP id 5b1f17b1804b1-49036048699mr56077735e9.7.1779373360377;
        Thu, 21 May 2026 07:22:40 -0700 (PDT)
X-Received: by 2002:a05:600c:1c0d:b0:48f:fe2a:107b with SMTP id 5b1f17b1804b1-49036048699mr56077065e9.7.1779373359969;
        Thu, 21 May 2026 07:22:39 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d44705sm63687105e9.4.2026.05.21.07.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 07:22:39 -0700 (PDT)
Date: Thu, 21 May 2026 16:22:38 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 11/18] arm/kvm: Initialize all writable ID registers
 from host
In-Reply-To: <20260519132905.145643-12-eric.auger@redhat.com>
Message-ID: <f049616f-d221-5f0e-95a5-e40d61637e0e@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-12-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mM1ZX06OWwLyUzKbff7H8BtOcF7j4tT1zkh-9iEaAKo_1779373360
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> We want to allow overwriting writable fields of some ID registers.
> However currently some of them are never touched, neither read nor
> w. Examples are CLIDR_EL1, CTR_EL0, REVIDR_EL1, MIDR_EL1.
>
> We want to initialize them from the host value, allow overwrite
> and write back for kvm afterwards. This patch implements the
> initialization.
>
> Introduce a new get_host_cpu_idregs() helper that gets the host
> values for all writable ID regs and store them in isar.idregs[].
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

