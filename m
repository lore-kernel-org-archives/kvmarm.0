Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66DCC2E0
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 15:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753285137; cv=none; b=aIZGZEKF9PB3mdobGqFraTUsUQuD35OQUERT91N3pN8p85eH4MTlYDV3rHSHSisctKpCUkgIf30h9BDxou6d3hWZdBYp4T3S7cvz418OxvPkm8RxU4yTlUsvo1D/gmN3YKZAzhjc2WoKzkQ9gN/yY4KG5oBj98S5RRU67SWTEPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753285137; c=relaxed/simple;
	bh=GqRPDz7Js6J5ALXU+f1ABPbcLmWpDxvD5BvBQq4in9I=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=d+Q8NISHHsZojyZ8FkVE8FakKY760OvDvQcnNGBfBOHjoWYkkRcvf7dy6lZokF2Mo+JEn2gK03X6TxDKgPqSg38R6UBBlZ3n0IHZFYbIDt/dNBZOyu7PR+URCDGeek1bB+v+XsB/dcLRooo2yvo+gZ5etgRuZg3RtEHEZ7WhRDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ns3jVO0m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ns3jVO0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753285134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GqRPDz7Js6J5ALXU+f1ABPbcLmWpDxvD5BvBQq4in9I=;
	b=Ns3jVO0mh/L10SRBys30F4GWTu7eHJAPcPmACQ0AK0NIzZPogvIG5Lyhk6KLLZvp298W4C
	unAIv5Q/xqgD2KxlZp49fYh+IP3u4+kiFzOAcu4rMgB1idHC8GbSpV5ETyuXPiH+qj+FMG
	5UNtLlnJZBZ7MsAbW+5uC8XZFGgvUcA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-kmcCNmB1M-CMa7u1Mac_fg-1; Wed, 23 Jul 2025 11:38:53 -0400
X-MC-Unique: kmcCNmB1M-CMa7u1Mac_fg-1
X-Mimecast-MFC-AGG-ID: kmcCNmB1M-CMa7u1Mac_fg_1753285131
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-456175dba68so54103485e9.2
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 08:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753285130; x=1753889930;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GqRPDz7Js6J5ALXU+f1ABPbcLmWpDxvD5BvBQq4in9I=;
        b=tzVpKRPC6TSG/8N2dhGZETMptrmgCWjp9Pb0SMbVFHy9EShyLyoCeF8FFA7Vz3BlIM
         YMJr0+qTOtJ3usSHoEdsKDtDgGl5HqU+9TsEhFTBcefxNlZabofp2OzcvQ8tbcTqMItr
         m/S9H2whNlZb2HHY+mX3CiVmMtCrX7iD3gLIAxykD1xMdrDJBNorzfiXYZaUEhUHrbQu
         WBmjEZapCYGOKIiY7lLXt0GqvYYkJs1b87deD77RHnDDiWueKQTCfbFss0U3kgRo9Oaz
         DiRxpNPe4Wx4dBzFchMB06wWbXM/RpcUVwo+hJAspEWRIaB8xCvmuw4/xtQfEsWIXoJa
         aw/w==
X-Gm-Message-State: AOJu0YwBGXEcm2rC7liw8A+LiRNCHdkKGs0TL4r6vwJ8ofhi1hLMsntZ
	VQRuzC/205SYTun8epgnUCVPdS7SUCgxyjCzCmhFe0U/5oQ8kk5gbjdFG02uymfcci/pzJXDXyU
	uF1jdow/Ax7hbdIu40MVLhxFXn9qSn4yBkk8j9+WxTqMyIrIjyJzy0sdsJPFmW7ye9A==
X-Gm-Gg: ASbGncs6Ii9z68OAlSoGpU3QCiRJLkWpdiZrQV3FQ7qjChf8WlzlEiDnSVTtYZgypL+
	Rc782/sW20EysNtnzu0QowmIFMoMs9CDZnk7eW7V+ZHKEHD54FOV6W2y3WcRzE8GGBPlHWu4jKi
	xqSaNOCR7yMMluP5LQU7ouTCDDXXXD+gBMQAjV7ohZTFHFWb1GdTwlqjcoftBNc2glhKvU87yyf
	STqGr3yGfthzDoIVPkUtsatEO9992sTdiYbK81WexVUj0YkNe+8NvocAefhScScgDRpEHGb7cTb
	CekDV0JR7j3bwDc1WwXXa8zSj2zAqtRdAPf+OYnVHYgplGgT+UE1wCFF8/wKeJwv4gH15EejcGM
	Uoct6hPPjcprR
X-Received: by 2002:a05:6000:2dc2:b0:3a4:e7b7:3851 with SMTP id ffacd0b85a97d-3b768f118cfmr2651213f8f.58.1753285130606;
        Wed, 23 Jul 2025 08:38:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5VNOZ06d9Q7sp8ekogChg0i83vEbzTHM1kvfRBR/uvTvD2QLTEPwMtYJKOiLyp1I3mVdofA==
X-Received: by 2002:a05:6000:2dc2:b0:3a4:e7b7:3851 with SMTP id ffacd0b85a97d-3b768f118cfmr2651202f8f.58.1753285130217;
        Wed, 23 Jul 2025 08:38:50 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45868ef50d8sm27988315e9.0.2025.07.23.08.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 08:38:49 -0700 (PDT)
Date: Wed, 23 Jul 2025 17:38:48 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
    kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 2/4] KVM: arm64: Clarify the check for reset callback in
 check_sysreg_table()
In-Reply-To: <20250718111154.104029-3-maz@kernel.org>
Message-ID: <cdf8ae33-192a-7e6e-8434-e8d336bea655@redhat.com>
References: <20250718111154.104029-1-maz@kernel.org> <20250718111154.104029-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FHP1bDGb3E3QvrqQpZzwXTdNzVrB6W1_EwVTvcOKCd4_1753285131
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Fri, 18 Jul 2025, Marc Zyngier wrote:

> check_sysreg_table() has a wonky 'is_32" parameter, which is really
> an indication that we should enforce the presence of a reset helper.
>
> Clean this up by naming the variable accordingly and inverting the
> condition. Contrary to popular belief, system instructions don't
> have a reset value (duh!), and therefore do not need to be checked
> for reset (they escaped the check through luck...).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

