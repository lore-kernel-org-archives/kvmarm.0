Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3CF288C26
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 12:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761567437; cv=none; b=F93ZhzmfNTc29dyyHbhFPzj8hbCf53NjrBKuz2xVFwqyigjpHflNySCpwhihhdnqfXqqDOIs0Gpv16qOMKi6jKZR/wOqcU01r88+9ru9ffXez8jajdOwUEkUSbTy3kJkodZpWRYcVM04lU2cLVa9FoDkkHQmMgR8RFZYejV1bUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761567437; c=relaxed/simple;
	bh=PIC6Rbp6UGjijidoWHy6JTwFmxirHwy58OvMbl01iJc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pjnBq+kxqpvO1EoSlEjV04ncDKkp/kbfigz47NtemKw0q6mPuZk8AU29a98Yr6ZybZ+ZlYsEJCiRKttrGJWjPqjV43LwQAq1kTaiKlll4CRf4IbOjuwgjcnNcDRoOHCwSuXfTPhiecuAenAZIzr7f0dqHRlrUTraCs6ZnjiOE5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDHuZpyw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDHuZpyw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761567434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RC0J3akmB3TXc++y+3XKXioAKP3259FgNBDBPlznVPQ=;
	b=GDHuZpywqQZi9TjaY9Zee/ZuIvYgQChKNyPrhXZDbxg7CIs4oRnHyha2uhfSAjuNjHr/2/
	DdT2INROMtV0rU9XvMnL0Nts2+TXkb4H7BXgslu486QKBo9O9yBWkSyWtPUWtpQnrsPAna
	QFJr0IfrKbO8ZxyppldQvAHTb6Ww9IM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-oyLMq6P0Mny4VzdFlOVxtw-1; Mon, 27 Oct 2025 08:17:11 -0400
X-MC-Unique: oyLMq6P0Mny4VzdFlOVxtw-1
X-Mimecast-MFC-AGG-ID: oyLMq6P0Mny4VzdFlOVxtw_1761567430
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4770e0910a1so6298205e9.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 05:17:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761567430; x=1762172230;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wll0xmsacByMeT/hOTkkX96EzOS2Mn1ybFdnjeQhq3A=;
        b=GhmveVsCWrcia56iQVvOxfj/BYpJeS7N0aU28zIWJc2KSjaja9523VVkYBFvD4A2hp
         sJyyYdjbdJ71xYbpplUMCANBlofveIu1oWZNElhkILpx+GUIzFvAY/9CCGw1mur62f6p
         2WoFcTWYicHTeQF8FqOypdnq3g1Tzgb+Mw46eRGeUdE2aPZXllGY6mTm882wLHwUm1PB
         zRORxCQ16B/AXvTWue2qram4g4++NNHfd6guaA5dtFv6+Ch33w4bUaeSeB3sudaVVlkf
         9Zj2Gl+oKmRJ8AZhU0LYmAAhHZALl5sBM/aP2v12DbF4aDzQuwJm1qoaOhEmvTHL70T3
         D+Ow==
X-Forwarded-Encrypted: i=1; AJvYcCXozqWLTJVNlnVnXvcE9Sxsl9sBl7p2wpSyCYccZjmvgS74+19O5GGW54p9Gm+MvbLknp0NHKY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHctNg1CLl+iyv2l4Pl7SoigEytFZhOyYy6fWHDcaQQdI96P2r
	ETiLHCcXCq6FHYcByMBEP+oTjlWNNtQkwWNEmtLEqR4tafa3CV6ENbMVhc+6bTZHMnuuYXhnlnA
	yp8fzryVKLc1i6jBcmI4/UWa/sSVk2JQdpUHYWc+teDjkHK2ooMlJPcwzXQ==
X-Gm-Gg: ASbGncvItyHjyK5C53LyutDQHmzMMsdJjGvMws8iUCUHBUNG7lXwNtt9GYR9BO+X7k0
	n3t6iwN5AdDrzvjvu+/EBV6Hap0e2V2hU2ZQI/KF4jIcX8f4bw4uRR0AMd+YWYAF85s3hz9OQWv
	rfb2kRQCiDqP/3hNArMp3Iy07ByUcxmFu7Kf4tYBdKL0efPL9rP1jvi9wF/SHOE7CCX8bHyHsme
	qQ0CjwAzjGojJpVbqHHBm9Ony8Nj5wRtA7CQybulrLlVOhfJPjLOydu/S3EKawGgVDlk2yy2u4s
	cOw/rTNYCjCoywp+Z/h/YLh3gyeZNL5imbbbnofUM1wVZIDnFplGnTous8JJ1Z10YW45eKPQmXX
	C3wBHuPj52lOk0SV5rbcdt+UbMmNfKMwSZ/260pg9EB2DMEaS
X-Received: by 2002:a05:600c:a02:b0:46d:5189:3583 with SMTP id 5b1f17b1804b1-475d2c2ffaemr87848365e9.0.1761567429917;
        Mon, 27 Oct 2025 05:17:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8Kt+sgYwnqm/Q4piYTRL+0NmhLKf29X3f9k3CyMYQpSiUpxteFuRbA1s4pQkL/YU8wr6E4Q==
X-Received: by 2002:a05:600c:a02:b0:46d:5189:3583 with SMTP id 5b1f17b1804b1-475d2c2ffaemr87848105e9.0.1761567429402;
        Mon, 27 Oct 2025 05:17:09 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dcbd243csm65775805e9.0.2025.10.27.05.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 05:17:09 -0700 (PDT)
Date: Mon, 27 Oct 2025 13:17:07 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
cc: "maz@kernel.org" <maz@kernel.org>, 
    "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
    "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
    Suzuki Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, 
    "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
    "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
    "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
    "will@kernel.org" <will@kernel.org>, Joey Gouly <Joey.Gouly@arm.com>
Subject: Re: Failing no-vgic-v3 test
In-Reply-To: <985e9c0d9079ea2a27114a8b088ddf10482e1f37.camel@arm.com>
Message-ID: <ae15bf83-df34-59a3-712e-6102bec59801@redhat.com>
References: <f9c7fffa-53ba-a506-b48b-07e3df2d1d5a@redhat.com> <985e9c0d9079ea2a27114a8b088ddf10482e1f37.camel@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ygqzJvFKgmr-STd3MXlhUB_tAN3hcOe3uXEetbQ3Gh8_1761567430
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463806286-1316213544-1761567429=:13240"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463806286-1316213544-1761567429=:13240
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 27 Oct 2025, Sascha Bischoff wrote:
> On Mon, 2025-10-27 at 12:37 +0100, Sebastian Ott wrote:
>> on an ampere altra I've got a sad selftest:
>>
>> [root@virtlab-arm11 kvm]# ./arm64/no-vgic-v3
>> Random seed: 0x6b8b4567
>> ==== Test Assertion Failure ====
>>    arm64/no-vgic-v3.c:66: handled
>>    pid=3793 tid=3793 errno=4 - Interrupted system call
>>       1  0x0000000000402feb: test_run_vcpu at no-vgic-v3.c:128
>>       2  0x000000000040214f: test_guest_no_gicv3 at no-vgic-v3.c:155
>> (discriminator 17)
>>       3   (inlined by) main at no-vgic-v3.c:174 (discriminator 17)
>>       4  0x0000ffff873eb587: ?? ??:0
>>       5  0x0000ffff873eb65f: ?? ??:0
>>       6  0x00000000004022af: _start at ??:?
>>    ICC_PMR_EL1 no read trap
>>
>> This is a guest without VGICv3 on GICv3 HW. The test expects UNDEF on
>> reg
>> access - which is not happening since:
>>
>> 3193287ddffb KVM: arm64: gic-v3: Only set ICH_HCR traps for v2-on-v3
>> or v3 guests
>>
> I posted a fix for that the other day:
>
> https://lore.kernel.org/all/20251021094358.1963807-1-sascha.bischoff@arm.com/
>
> Could you please try the fix and confirm if it works for you?
>

Yes, that did the trick - thanks!
Sebastian
---1463806286-1316213544-1761567429=:13240--

