Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E78F3D9699
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369824; cv=none; b=lTiLXTu10fKRcUlLjPF6GF8tp6dy40MNx4ppoZpyWfkjz8iz/0+ueQuWGT6269J8TTxoq8wUGGmzYqECqtcXwFwD/h3jygMCiiqHQd62aCzc4JmxUej2COK3nMIGQO68h1R/MIYDhtm83n8alFiBCrLhAnPp7nXPZ8gKaN02mLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369824; c=relaxed/simple;
	bh=bthRsReiJ6bBSDWfUl4C+rA7io2uCIvhq3b4X9FNb5Y=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WOBYg9j1HmQVcHg42+WhJyRxLeZLvnHJ8yk3DNYhU7hpwikiY55RosxSY736eOkv35h3nUfpci+u5XYTiQqz+iJtl1hh8ZlKijDgJ6JkHTfYMn4KoyCeAxNIRaEEzRDATkLAijk6Lb1UhLN117lEPTavIVwYXpZoOVGyPfI5/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bm0KWw+O; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bm0KWw+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779369822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bthRsReiJ6bBSDWfUl4C+rA7io2uCIvhq3b4X9FNb5Y=;
	b=bm0KWw+OrftqdQP0ejEMfkp1u1Wob+5YGWj3DAJBnH+gtsrjfuUBxZlPTGARU7SaHiSWjm
	2xTDy745T5LeA9I1UlvQc6Yy61NHJKffN/r8THKW19TRrfhGRo3rWS3DeyjfhVMyWrajyd
	UMviRg0YvJmgqFl+F01fdh3QziRWGNY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-zM2wC9sXOiirfzMdYZbpgA-1; Thu, 21 May 2026 09:23:41 -0400
X-MC-Unique: zM2wC9sXOiirfzMdYZbpgA-1
X-Mimecast-MFC-AGG-ID: zM2wC9sXOiirfzMdYZbpgA_1779369820
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-447f2ce5556so4872236f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 06:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779369820; x=1779974620;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bthRsReiJ6bBSDWfUl4C+rA7io2uCIvhq3b4X9FNb5Y=;
        b=IRoFjolYrwTDN9w84pjtIK4k9GG4UOeAC9yt0kj8CKIhMln//c/ATzNlFKL3gM9d2J
         JO4s1l63tNMM1GmxHVBw4FOYVQHIgfg2K2yr+kA58iMVIe36Qn8VuYATKImXhccbJ9Sm
         ltiRoynxHWvyEGg4bW/eqUT+29C7dum+BNlz9YGpVQPYKCBWggZmk3ZI6Pv5OmlzHZ9E
         xrw195rXD2QLHhYAyY1Tkqelus802R6GgHuiBwEaLsneAg5zZASxP4OgH01bD//d5QYn
         FMcvpa1OgWI6Jsc8Zop44KAR1Lkv+W4uamjOpIbP6poFULmQYJj1TE8dLy6UttFn58HL
         S3Xw==
X-Forwarded-Encrypted: i=1; AFNElJ8vYkin1ZYZGCVjFtSXhWNodpo3hnR56JKnOjN0fT1GWhhhzUrVDxhVr2Qm3ppSJ4nfEHGcx7o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0lNS+ILwYoS7hg8wpa48mNXFF++uY6zR74crZxIuBOE9yY36L
	COqDhjpWnl+fl2rJI+XVof8Z7DjyhOO7dFsMunmSsSUxzQh83dGt9gUftRVV1dh3CkRYgZsPuwQ
	138vCEWJ0nVEYUDPuq4OopeyJYU6IWKj+iXUPmNa4iaOlRWEU9kHf1OprlQ==
X-Gm-Gg: Acq92OFhwJly8S7/VQ1LrRwsINToC2yDczXbFKM3s+/9GIHEZwE9/BYtArm6y4mX+Ik
	CxKaMpaaboNyyVNSjxffOoSDH3FMFdBrToJA3t8713Mz/ip5jrqxQLC8AQRbKMz+r94znKckfsP
	PiAeHyLfeFjHbQjd4i8D2tS8vlujuL0ozDD4NIhjs9E7CwnTVCq1yFwt9dPqeOkR6KiAREsAxRw
	lDkkLFPgBOspQJ9TXx6KlO9RUN/bmZVxl0201BzKQiOMqwz55r/ItocSjqX6lwaNTwj7RZZF5tz
	auzVVPcl9hptRyvSJXZx1gZS6joUohfln6czlRmWmw8bMDljln2Buwx8ABTtLaAOQYCH1MWVLTK
	+i3XVyng5ZNm3SO3vIAPlPC1qCS6CZ2g7oICtCZKv2jfwh6IZZUPiagVoJaBvUfNjTZ0LSPSszj
	oi6JfCcg==
X-Received: by 2002:a05:6000:4808:b0:44d:1338:46b4 with SMTP id ffacd0b85a97d-45ea36b42d0mr5074876f8f.9.1779369819892;
        Thu, 21 May 2026 06:23:39 -0700 (PDT)
X-Received: by 2002:a05:6000:4808:b0:44d:1338:46b4 with SMTP id ffacd0b85a97d-45ea36b42d0mr5074819f8f.9.1779369819402;
        Thu, 21 May 2026 06:23:39 -0700 (PDT)
Received: from rh (p200300f6af2a6100f239e076bbd76784.dip0.t-ipconnect.de. [2003:f6:af2a:6100:f239:e076:bbd7:6784])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eaa93630asm2673560f8f.25.2026.05.21.06.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 06:23:39 -0700 (PDT)
Date: Thu, 21 May 2026 15:23:37 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
    kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
    yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
    skolothumtho@nvidia.com, philmd@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, pbonzini@redhat.com, armbru@redhat.com, 
    berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com
Subject: Re: [PATCH v5 04/18] arm/cpu: Add infra to handle generated ID
 register definitions
In-Reply-To: <20260519132905.145643-5-eric.auger@redhat.com>
Message-ID: <c0644ecb-fc85-3180-e11e-99ec154a6e15@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com> <20260519132905.145643-5-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XqUP15Ja5m8GtrnoqHFsrV0P__3zcYpZhfgLx8q1q20_1779369820
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 19 May 2026, Eric Auger wrote:
> The known ID regs are populated in a new initialization function
> named initialize_cpu_sysreg_properties(). That code will be
> automatically generated from AARCHMRS Registers.json. For the
> time being let's just describe a single id reg, CTR_EL0. In this
> description we only care about non RES/RAZ fields, ie. named fields.
>
> The registers are populated in an array indexed by ARMIDRegisterIdx
> and their fields are added in a sorted list.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

