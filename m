Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216621AF697
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718898291; cv=none; b=muimYQZHVC2u1EtZhtQVIGpfrPtO4VWpo3kSGYUz5BZWY5s4vmOcTtdy8CANTmPpaG5BcYrR/4iz7e+v50n7htq+hDyXWtFsy6HWaAaHzAGMhvTStU6TrJPwiPXgFRq2Jk8T6edLSkWlXLnBFwQFyirfDaoTe2JFReRVGEu2BTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718898291; c=relaxed/simple;
	bh=T5peMHLH2/lvV5zPTywsO9a7/KHjr91Ck01nEMXty4M=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=cKFhhdLxLbs+4RC1zFRRox5exTegV+xwOWskRuGDMEoHj/HZrV6THTaEEKkglutMhv4guQN2AE9tCVqA0NldIjISHn2M5aBHy0hjDdIb77k9ZcnSNe7NXAzmLMXrq3HiGeJ/qwAFq34RnLeH67xV888x19tGvl5LSMt+WGlVg3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YoPLcVPN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoPLcVPN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718898289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T5peMHLH2/lvV5zPTywsO9a7/KHjr91Ck01nEMXty4M=;
	b=YoPLcVPNN4ubwUyYAf3QO+3BGjKIqmiXuGrwXaV8dN+mN77bcVn8CbwnI+xtxw832bBMdV
	HSigW96UP9zi1CPFzdqY91MPzuuCVH5dZjhAY2MmIF120KdjUOfQk7blEoj8enkONQO2T3
	SmdwDW7Kz6yrv2R8TgMxLgsl6f48uXQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-j47b0FwtPoqfDTLrtPJgEQ-1; Thu, 20 Jun 2024 11:44:47 -0400
X-MC-Unique: j47b0FwtPoqfDTLrtPJgEQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b50430e9c1so12483236d6.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 08:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718898286; x=1719503086;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T5peMHLH2/lvV5zPTywsO9a7/KHjr91Ck01nEMXty4M=;
        b=e0Z7+gnoqXG/rfQ4ZeEIGJaWpSrJKa+O5QmTqM3CzkRwJ64VhL3sWfiwTIigl+APUN
         HRde51cwBfSwPowesIvY0qmF76UCZjqFy7c1QJ5uMv4nYR1MA9Ynmd8k+WaZkZuDFXiW
         QID31zP8jE5Kef3iGhwHw7q40bH5w2/uEBAw2RH8rQV2UaMv2xIOwV5AM5puLkklp3Gw
         ztUGW+LKW+Dp0MtJ7ti3w7Q5Xxk4q1hYZG/BYYj74ggF4opu3SGcA4OUDl35Yw9y8Gsd
         0YkRG5s3CbG9ERK/fIMg+roMQAl8+DSawK2+2VeSCKqRST30FMyn4Xl62gXLJw4aTdge
         98+Q==
X-Gm-Message-State: AOJu0YxTar1Tsz9YxKqOn6BfQ98KYyxvKOKPuuKps48A8/rmGviyoDHm
	5w6sFTKvZb1uNIZ56gwj5NIwrkNS25KCKPcwdOitQN6A7MhhYyLJ+WZHUcsc6ZxTwpovpGseE1X
	bo4amDh1No6wwK3Z9WdfiRGp4Jmt8t9Xsr876eCuQDhY0iHSo0XHvAg==
X-Received: by 2002:a0c:da0d:0:b0:6b5:81f:f14a with SMTP id 6a1803df08f44-6b5081ff707mr52685026d6.36.1718898286640;
        Thu, 20 Jun 2024 08:44:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0D5QNE+vRsG3anb4CDlhzXD7xleeSKu+MYv+Clx7k8Xx+s7A3qB3oJAXsBuJ4oIJUVnKc6A==
X-Received: by 2002:a0c:da0d:0:b0:6b5:81f:f14a with SMTP id 6a1803df08f44-6b5081ff707mr52684896d6.36.1718898286381;
        Thu, 20 Jun 2024 08:44:46 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a9cf8257sm86445916d6.56.2024.06.20.08.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:44:46 -0700 (PDT)
Date: Thu, 20 Jun 2024 17:44:41 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v5 03/10] KVM: arm64: Use read-only helper for reading
 VM ID registers
In-Reply-To: <20240619174036.483943-4-oliver.upton@linux.dev>
Message-ID: <6367a0c6-e1ad-41ae-709e-be3746b6ba3f@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <20240619174036.483943-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Wed, 19 Jun 2024, Oliver Upton wrote:
> IDREG() expands to the storage of a particular ID reg, which can be
> useful for handling both reads and writes. However, outside of a select
> few situations, the ID registers should be considered read only.
>
> Replace current readers with a new macro that expands to the value of
> the field rather than the field itself.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

