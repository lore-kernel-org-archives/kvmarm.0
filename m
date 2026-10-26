Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793022911;
	b=ISzrC65Fh1c3Zc77jwPuwj0ZkVpsfxl9z5qzbqsbuWoFXv9zRB5lYSFM36xtq8nU1Nak
	 pOVWigtKkqDDKRfqKWqCysRBGMlgq7a+tQwKI5c5Gv+edpE3Jt+P9wrKca6d0IQN509It
	 cz+ErFiihk2y1kEjCG5zYKqhIuO9ZZL7D+LXzqVay16X5cdvNGT46cjDjSm/AWFy0mR73
	 ntqQgLhblI+N6gkZ3RWoYI1Uqf9O2AISVg/XcjuWSRFZCqHOAdV5uldEGoNrKxUU2zcy5
	 nK8b4/lI+QZK8+YB0UfUF4iFPzmq7XATumpSk6/8KcmP9OvfmY7RHe2ZaRewYC0hE2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793022911;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Reply-To:
	 Subject:To:Cc:References:From:In-Reply-To:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Language:
	 Content-Type:Content-Transfer-Encoding;
	bh=AYIyUjcnnUXti+/sgQo976EJjdmpRoD/s64kOynFb+I=;
	b=ZuvrlFDeLChF4kVieYOLolnzp3gGiSxaTWENGe9k8Vh4PZjp5I50T5Paa0hh/sCc+d82
	 U6xxh9hINFwzLO5xgzMRg8zDnEdz4BzxyYoxXTDPsSGzW2xyXe0yucm8pwXcSwXsh1dlA
	 Fb3plNntXPteVKDU4o++riLeKiV7qf2TkiMaOQpNYa+Zh9FW96GLmGTQEXH0kxJBgrrSI
	 aU8hYFdsB3Q2f2FJMgmIis+gGj1kw3TefvK+ZO69H49U4Be6NqeRHWRaYsXshjWr+va6Y
	 Rwdlms7sXJ19DvM0Ah9X6Bmllt6t86v6VqiHXtpjts9zPjoeAkbVHMQ2jrT1Ch28d9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=chC8QJe7;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D153606A31A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 13:55:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D153606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=chC8QJe7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793022910;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AYIyUjcnnUXti+/sgQo976EJjdmpRoD/s64kOynFb+I=;
	b=chC8QJe7wtJlrW7GA5u1hAPphGmzgdWz800N96GIGoXpR88i6gD91cB9Xb9cZiNEs0Sd26
	17cirS7L7ZBuyxW7UEkkmiPZvlbXy3AgT6srPifnMVUhppQFkTSAKD6glr6/SlfDYxoXUX
	xS1vSA3Up3mtNcgNr/wK6oOJCVhIyqY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-bTkpP5GyMXCn4wgTMhzd8g-1; Mon, 26 Oct 2026 09:55:09 -0400
X-MC-Unique: bTkpP5GyMXCn4wgTMhzd8g-1
X-Mimecast-MFC-AGG-ID: bTkpP5GyMXCn4wgTMhzd8g_1793022908
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49febef74e3so27683825e9.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 06:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793022908; x=1793627708;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AYIyUjcnnUXti+/sgQo976EJjdmpRoD/s64kOynFb+I=;
        b=nRW62shKiSH+EkvIrvbh+lPU5xd3QxIewRkJw//5yNCv65sQR55nYIs6l2cvBhIKFV
         rWVP7RioE4Ed65EQj04mSlwFJjsZL//bxTFvXXkE8Oz8vi2OfJCFx/ym5b7tVXpkE0lN
         qRvHitU3+xjrK3cZKGl67ChWe/UPA7CTedkeLEJjRcGuFzAhXWBake5kGAFIfUffMG/d
         9RPdPxILemCJD1NjtQJGnUnzFYdsDAwgTh576OZKNY8VC3ENOWi/ayQtdPq/G1YxBdp8
         2XzqwiR5h2sdSVxAoG/8WctQeX/xuzdSQIc4FQRYf44dj4zXrrRkruvXDymwH9vINABp
         ESlw==
X-Forwarded-Encrypted: i=1; AKwUvBw35aqZM2pryC6bweTuDYUeiYzn6ByyKnMYXjWoUzlYCp9gpAMCnB1ZOiJwFeTdnruYJY6f0TM=@lists.linux.dev
X-Gm-Message-State: AFq9FYLwH7XnuE4ufDN/PS0o/B/OaAMd1YzUj4Rd2g2ZZdWAXmyeGHWU
	stCJU48opotZjfTwuGx9+9aPUWuIEfNylJAHjW+Z5KIebTHy2gwOG4fwKeizxFFvmzYcPKtHKvN
	SE4ZHaNPd+xJcNE2C9FptH5tcKx+MLryyt4VVGaiWwDFrMlWqSAl69mn+lA==
X-Gm-Gg: AYBFou01KXYTF0vRWR/xYCsgzTqVTHA6RF/OKSAzthiqZ6XuAHrJXpltvJLAmoI8Ady
	cnE07OnFmmN59G7HlKHuLqQ0qUGH5b8lHbx04rYo4XapSRTYi33Blr193xhEHtHW+EL+K/q/4YO
	KcbTFkurb9jXFoiyfSjroHicqmBuvP4mCQjO3tsudhSD7G5C0KIuiBafUFAwYwGp5TrZq3z3fWa
	HRSr/oPSn/r2fMuYUqsYLkk1NyNHT/ULMyV2ZLaXQJs/SXsTLYdGgRl8+DHD5JeKvhA+/mX1DvD
	fMYtW5tK3WMq8I0Qsf1BXuutgfIwAy1gtw4ax99HjbU3xZ6kQlXEP4DUquPk5XOSPKX/mhmINyF
	RqhlurU/zjUYt7tM/xi8ADK3JA1yqHBcYupBkg4c9J1SsacRs
X-Received: by 2002:a05:600c:4f05:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-4a35ae71b30mr145150315e9.5.1793022907666;
        Mon, 26 Oct 2026 06:55:07 -0700 (PDT)
X-Received: by 2002:a05:600c:4f05:b0:49e:65f2:db64 with SMTP id 5b1f17b1804b1-4a35ae71b30mr145149665e9.5.1793022907163;
        Mon, 26 Oct 2026 06:55:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a56992dsm186668015e9.6.2026.10.26.06.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 06:55:06 -0700 (PDT)
Message-ID: <71a7a633-b0d1-496b-a4a8-fc887aaad685@redhat.com>
Date: Mon, 26 Oct 2026 14:55:04 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v10 00/26] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, shaju.abraham@nutanix.com, khushit.shah@nutanix.com,
 yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org,
 sebott@redhat.com, skolothumtho@nvidia.com, philmd@oss.qualcomm.com,
 maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com
References: <20261010133725.642498-1-eric.auger@redhat.com>
 <CAFEAcA9XE0TLxp+DNzFSbkxbj7f0M78N+tf1a01cJ5rNkM7NBA@mail.gmail.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <CAFEAcA9XE0TLxp+DNzFSbkxbj7f0M78N+tf1a01cJ5rNkM7NBA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lrZ3TrMI--9pe3HIP3kaF9aP-ulaR5cRXNFweLBDeGs_1793022908
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Peter,

On 10/23/26 1:44 PM, Peter Maydell wrote:
> On Sat, 10 Oct 2026 at 14:37, Eric Auger <eric.auger@redhat.com> wrote:
>> This series enhances the current host KVM model with capability to
>> set writable ID reg fields.
>>
>> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
>> of a subset of ID regs. The list of writable fields continues to grow.
>> The feature ID range is defined as the AArch64 System register space
>> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>>
>> The end goal is to get more flexibility when migrating guests
>> between different host hardware. This series is a prerequisite for
>> aarch64 named vcpu models.
> To help me with review prioritization -- are you hoping this will
> land for 11.2, or are you expecting it to be 12.0 material? (Given
> the softfreeze date is rapidly approaching, it feels to me like
> 12.0 is where it's going to be.)
for the whole series I think this is too late for 11.2. What would be
nice to get in 10.2 is some prerequisite patches like those you reviewed
plus [PATCH v10 16/26] target/arm/kvm: Pass an Error handle to
kvm_arch_init_vcpu which are rather independent. I will prepare a
separate reduced series containing those + fixing the oversight of one
midr conversion.

Thanks

Eric
>
> thanks
> -- PMM
>

