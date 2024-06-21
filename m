Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4207374CB
	for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 12:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718974541; cv=none; b=GprN+K/Gt6W7oq3dC7hq1g4KBEJeJQSP6Rl/eY8psd5aWbFTES48GainKqVI/8nK5sK9wh36HAvyFWunkqU4FnGUQOty5IUmqaEgu2v6gLAznSkbNYknr03G+giudGQ75Q5VHowIA3mnOQoqrdmkWpHuswakkTwQg2+DPb0EDzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718974541; c=relaxed/simple;
	bh=WO5X9rdCDOaQUclCdQ5IwzctuaRt5w4su9JfUjNIAtU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tQAhWC7aKkz6v4BZG9U2MBBrYI+ke4Ns4RJEq3HQLLV2eGr5jtzitklXJJcBoeDIvQt/eudNRp8rp/uSoJ8zC8Gl3xzpcNgGmhGbpb1e4DpGYGKyrYcPRo9jmGIkpkFlbh3zRNfVxqAusAEtmQEq1RiL6ADFrJRhUwsI6VpcTWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eAKdxUKk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eAKdxUKk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718974538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qvyso1coD/Ch+E1k1+dQ8v7aJZZwA2hNY2CehO6gBTc=;
	b=eAKdxUKkmEA2Pkaj2QYF/MeGTNX/U6tUxEMGqcbYbXlnzILBEI67768n47auAV546WPCn2
	1UQnSEBjNPExYQ3aCMUNg9JArHDnqGAEl0xO3VRBozQW9oav0d0jPg4aSJiKq3l0PS9HMi
	/Vo8jmfTvPUzwf9A1VVB3+rTZdgKIh0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-I1sOWWRdP9yVO-vsevBrEg-1; Fri, 21 Jun 2024 08:55:36 -0400
X-MC-Unique: I1sOWWRdP9yVO-vsevBrEg-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6b4febeeb1bso23772106d6.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jun 2024 05:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718974536; x=1719579336;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvyso1coD/Ch+E1k1+dQ8v7aJZZwA2hNY2CehO6gBTc=;
        b=sOl0m4RuXqj4W1pGbNv68RsCfqpfoC6ouzfw17J7qecYsqNYTOq1PbQObPVjSx0O6W
         TJhK2JlIeirhc5sRTEQN/uQpoN5To9c9kVsl02xruJZY48t7V8dEoTb3jHbsyUdq+pS6
         PGveLZwD+hsKtGsZkbgwRw6qyRZO0QLXsvKCgbza3eyy7DrzrVE/iPe9+oGUQ8JTJIr6
         f//BJtlbUGD43xKE8m1KR2a7RNuX5QDogvEa6CbItro+RmNxf+TpmBPUJGjbAUuYPicx
         dY3cnOfKEzEdQ+AOllayBmqitKhxzKjDaB9MhDk6TfX+ll5dgJIMkAfTL0wuFqyqpthP
         XpGw==
X-Gm-Message-State: AOJu0YypuZ1fud3IAawfw9lrat8xMrU+7c/2kkNmPurNjd07nhQhRLeJ
	V2HW0ET4QG7Vkf3pXxKS3HagEjSwE+2bmUW+99X+GILJ0ampeo2iWVARQ6QhpWorVU+mbgBkhJ1
	X0VtczSxjD5OojSwU+iS+NOJ8qX01PIo0TugdHUDckO5aw3V17GlFzw==
X-Received: by 2002:a05:6214:caa:b0:6b4:dd2a:aa44 with SMTP id 6a1803df08f44-6b501e3ca5dmr137927246d6.37.1718974535766;
        Fri, 21 Jun 2024 05:55:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQKfszEYeuIrPEQCSgtqiyccBoeK+6p0epedPO7UJVfwJ8/ib5x4aYN83RsU7kGBTVQbJc4g==
X-Received: by 2002:a05:6214:caa:b0:6b4:dd2a:aa44 with SMTP id 6a1803df08f44-6b501e3ca5dmr137927086d6.37.1718974535390;
        Fri, 21 Jun 2024 05:55:35 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b51ef30d30sm8608716d6.93.2024.06.21.05.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 05:55:35 -0700 (PDT)
Date: Fri, 21 Jun 2024 14:55:31 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    James Morse <james.morse@arm.com>, Eric Auger <eric.auger@redhat.com>, 
    kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>, 
    Shaoqin Huang <shahuang@redhat.com>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v5 00/10] KVM: arm64: Allow userspace to modify CTR_EL0
In-Reply-To: <171890515830.1223590.8660930452290685977.b4-ty@linux.dev>
Message-ID: <ef9b7e06-a609-c961-2a19-f6c40f7e9bfe@redhat.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev> <171890515830.1223590.8660930452290685977.b4-ty@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 20 Jun 2024, Oliver Upton wrote:
> On Wed, 19 Jun 2024 17:40:26 +0000, Oliver Upton wrote:
>> As I'd mentioned on the list, here is my rework of Sebastian's CTR_EL0
>> series. Changes this time around:
>>
>>  - Drop the cross-validation of the guest's CTR_EL0 with CLIDR_EL1 and
>>    the CCSIDR_EL1 hierarchy, instead independently checking these
>>    registers against the system's CTR_EL0 value.
>>
>> [...]
>
> Applied to kvmarm/next, thanks!

Great, thanks a lot!

Sebastian

