Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7F4213E82
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 17:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738690936; cv=none; b=LFiQxxGtAhIFsgzE529vLYX18oro2qVvvWIg5D14zo8mwl2ge5GQJuuprp+70s1qJuB4sGWMW1fYzRbnNcLFF4wlB7fbfvMUejfwqCMNh5mU9m1yMhHoio4Q1vrmWrxvQE0ZQ+IyFsm668bdY5rDKWwPHF2OnA1FI5491JP11ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738690936; c=relaxed/simple;
	bh=C4NeFOJmhxb0HadgLbXrVb+Dqs0SXVQJ1rxhMk6r+zU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YnGNyu60//zWpmQ7djLQ3M4d7DVZpVScyG3uX7uw/5Fy0aEnl8hpSW7+WOfGFLMIHpyLcgLcIhca/oJt4lZ4JcjbdrxL3W33ytPWKlrZ56+W/zsgEW4j9QwBV+/7popnALirGxSy07D8MbasJLxm8ajtLtkkBg9W465RwPX25io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M0TaIpBW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0TaIpBW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738690933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4NeFOJmhxb0HadgLbXrVb+Dqs0SXVQJ1rxhMk6r+zU=;
	b=M0TaIpBWkRzS8BxoQgCPytSff0SrcceY3eiJ4Vk8TBg2tV4Wqc5egnKgaAuZPB7vEUDJWx
	sKYAA3zI8y0qrPc/7ssykHpgPKrrKfU2YedDVPjEWIaP0DbPo/3zRVbJfip+tEst6w27LC
	vkbSqEiB43x+RNe3rtdeT04Dk/fv4rI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-k6w-K0KgO72VGQtVm-Pwww-1; Tue, 04 Feb 2025 12:42:11 -0500
X-MC-Unique: k6w-K0KgO72VGQtVm-Pwww-1
X-Mimecast-MFC-AGG-ID: k6w-K0KgO72VGQtVm-Pwww
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-467905ab1bbso52810071cf.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Feb 2025 09:42:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738690931; x=1739295731;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C4NeFOJmhxb0HadgLbXrVb+Dqs0SXVQJ1rxhMk6r+zU=;
        b=hYKYMG8Qcdrm2uv8q3Db1YAJctpS58G8fugYrB7do2MA4vdrYIbvli/Njzn3bskiBF
         B+te7qCkDI9Oj0Tz5UuPFc7kug6bXA8ovhSBdfPSIKQgntZHjSu4ZQfTiTrs6jbuVwm0
         PbstBErzKfN1dCJO0npv+oRPO8t2ycqbFJpe0l6uNTxVGjbJDHfms86QEI03waRV3DQR
         B0jk/ZYzqAyCAYVFgUSJermDrUaiF94j8fDC0jwO4zyayJ1RzLb2v497UrhMic+CNBLq
         bqGJKnJifXxpJzm0+zleEmAkv09RcRNw8qklDVl/nlBSF9oMg0k3vtoWyR2ZomCDMq1i
         Fayw==
X-Forwarded-Encrypted: i=1; AJvYcCUmZFlnF+vnigZESx0FKKingj4P3296cE8WcLFqQH/RqbA0pPquujEgGAssA6vwrFEVWw14A9g=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr0cYM3ex1GY3M8VORyWQJWITSQ7fLI8WVYI8lNhSFwfMPR+65
	fbuRq+jK/mCTfhTuA5U7IR6+bgps6juEUH2dUQpXMzokj/+0hlk2WrY356zrpX2VG/gKnBssPij
	XTViMsoGm/YIExrK5UcjmWn/BxHG3+3ECOvOPG+l7AEbqZHtHxQmy3w==
X-Gm-Gg: ASbGnctORE+hEtJkMTsPCnZnC0F7ttqAxoyLRJUWUNpEa6CSg+M+HGr6QgEA8D8g4k2
	OLkIR4f8t4mf0gwuVsB3QmH/BagTqeXRuqILhyrKQ/b0J9M5tgWNXeWKVmoAaqEQPNuv5zD9gk+
	sbDreg0+BOZLyZDUYTKhZeTQ8/HPZjLsBi1qQssB5e3ND08VPdG5fPl8MCn2E6KkDwHHZe+veVn
	1crz+hlNS/vYt0YSvKNbRZdAgSCoHQG35RAiGUFAjucgzsqCp+Y4Y2MGRtYKk17CDy/bnPI7rb/
	j/z0akr8KltjTDqBOLb04POJyGuBvGBY6RXINNpRohbUFaEM72QEFg==
X-Received: by 2002:ac8:5794:0:b0:467:7fbf:d115 with SMTP id d75a77b69052e-46fd0a6c343mr368814651cf.12.1738690931456;
        Tue, 04 Feb 2025 09:42:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnrxHtljGCWfirB5phvdvRvD1W53cyjXxbXjd79D0P4Hi/IOz77ZQTfITQwFUokPOGeRBSzw==
X-Received: by 2002:ac8:5794:0:b0:467:7fbf:d115 with SMTP id d75a77b69052e-46fd0a6c343mr368814271cf.12.1738690931098;
        Tue, 04 Feb 2025 09:42:11 -0800 (PST)
Received: from rh (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46fdf0c7191sm62333371cf.21.2025.02.04.09.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 09:42:10 -0800 (PST)
Date: Tue, 4 Feb 2025 18:42:04 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
    kvmarm@lists.linux.dev, oliver.upton@linux.dev, catalin.marinas@arm.com, 
    will@kernel.org, mark.rutland@arm.com, Cornelia Huck <cohuck@redhat.com>, 
    eric.auger@redhat.com, yuzenghui@huawei.com, wangzhou1@hisilicon.com, 
    jiangkunkun@huawei.com, jonathan.cameron@huawei.com, 
    anthony.jebson@huawei.com, linux-arm-kernel@lists.infradead.org, 
    linuxarm@huawei.com
Subject: Re: [PATCH v5 0/4] KVM: arm64: Errata management for VM Live
 migration
In-Reply-To: <8634gtvdmi.wl-maz@kernel.org>
Message-ID: <f42ee0db-645a-8710-d611-8e45c4e1a4e4@redhat.com>
References: <20250124151732.6072-1-shameerali.kolothum.thodi@huawei.com> <76172c57-aac6-d540-5b98-8de100c0886c@redhat.com> <8634gtvdmi.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BAaFXuuazNp8_mqN5z9AqVrCVnMgUlDwseBOw9H2Vl8_1738690931
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 4 Feb 2025, Marc Zyngier wrote:
> On Tue, 04 Feb 2025 16:45:38 +0000,
> Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Hey,
>>
>> On Fri, 24 Jan 2025, Shameer Kolothum wrote:
>>> On ARM64 platforms most of the errata workarounds are based on CPU
>>> MIDR/REVIDR values and a number of these workarounds need to be
>>> implemented by the Guest kernel as well. This creates a problem when
>>> Guest needs to be migrated to a platform that differs in these
>>> MIDR/REVIDR values even if the VMM can come up with a common minimum
>>> feature list for the Guest using the recently introduced "Writable
>>> ID registers" support.
>>
>> Currently MIDR/REVIDR are still RO and guest access is not trapped - so
>> even with the errata management patches in place the guest state would
>> change and a migration (between hosts that differ in these regs) would
>> not be possible. Are there any plans to allow to actually change these?
>
> Sure thing. We only need a victim! :)

;-) Nice. I'll hack smth up then.

Sebastian

