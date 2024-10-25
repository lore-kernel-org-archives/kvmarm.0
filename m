Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDCB20651E
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729861522; cv=none; b=iwKiDra8pqPCEsMDbEzwebUDCHSgdLByzw3tbm1Nsxqt4IxSnfloIraqZS7b/j/NeZX/ND1ZxRDjjhVG3DF9TypjnunKwVn0saXgC1oVlTFsrcczIcfrkEAAYsUsPF+X7i3DDEufvAbKr2zrHFG/mxuppa9HfKF0VNYMXYZ+FBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729861522; c=relaxed/simple;
	bh=UCLSDO/jm1mAVqY7mkCIBEwU4gXpjBMrnFbP+zDQ02c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZK8r80UL7BPwhvGuobUiAiU3le1/gCsDzO62DG+A3+w7RXYZuEaDdw4O+Lt7RrWsrlRpO70ad/bqfJWwGaw+q1hR6MuLJeqEW/JiYdiwaiPBYJVJTY/8Vbp5sYOb1ZHr7xE5Rp9pr9QvULHZu85EGulYhM/F77ZvpS+//dR6w14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aSBKpYGI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aSBKpYGI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729861519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NN2SUD+OUfJKgPj+21gkXoKJrVd7DZ/UXCkZWnA0qJs=;
	b=aSBKpYGIKK7D+KGs3+iXX15qBEbA5LceCf5I6B92iBQHVqNikzIxSSFLDfK+6Gtfm7/1qh
	Xau9Njf4xVxDoK11WT5lKnQwOaNC5bZpkpOn8ySdbcOKgUvF4s382kPS8gq2YsiFyam4mr
	+j1XP45XVwyEJmyeCnySLFaHuD4Ia7c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-ajUt4_eCO_iUIK0b6BcmSg-1; Fri, 25 Oct 2024 09:05:17 -0400
X-MC-Unique: ajUt4_eCO_iUIK0b6BcmSg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d4af408dcso958868f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 06:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729861516; x=1730466316;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NN2SUD+OUfJKgPj+21gkXoKJrVd7DZ/UXCkZWnA0qJs=;
        b=l4rK1z6NU6t+eE4Xskjghe+CCUz3t5c8UgsEeR16Rt5ZYHXneSSo1a0XXbTLTPYkBS
         tFYesNhakr7bQ4A7YA0Q/svgNouf1SUYMitDvj6gBUkgd5k7AwjN8pR9vgwWCyOxZmbW
         9O/zS5Yr339+DfM9FQ6AuV/Kg8fl7japSd5biHrSU9OTBAznlVva2qvZ71Hfa+MzKDcR
         nNpP8ubU2WRQy3tzhoRQFJuEeytxVJi1ymvXMD57jL91WJAwPhcHzlnEhBHYlX3GNZ/A
         +TCyrZpfY5LJhE15pPhv7fF4ebMviIXAAQMJzq5I7deTSJGvdRyTst6DFniachJQajYF
         9I/A==
X-Forwarded-Encrypted: i=1; AJvYcCVjQSrcFspXaA9HmFAeQ1zdx7RtqcLWQg3McgKuGIWI5RZQz4w50miQteAhpvWsQwnNKnnlVso=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIjSG1VTfjD54eSchq15QHITqXnC7uJzys37uIAgThJvA/3xfl
	xsibel1hmTr4pPuFMVxY2sEHcH/s+lvwVs4X/hYY/ll4DVfyYl8W3OQsvM400nRVRpGEg4ukLHT
	2OYzE/f9dHnBkNV3j7q3eDYYbjiUnJatlb7FwaeMLGqB64C4kVqURpA==
X-Received: by 2002:a5d:6189:0:b0:37d:39c1:4d3 with SMTP id ffacd0b85a97d-3803ac84451mr3932492f8f.6.1729861516616;
        Fri, 25 Oct 2024 06:05:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHZX9EQgHC8n+5rGdSPJEtECAS97R5nQ80Ja/EQnqyzVVLXnGbDJE3YBe+VRN9JY0lWOP/Cw==
X-Received: by 2002:a5d:6189:0:b0:37d:39c1:4d3 with SMTP id ffacd0b85a97d-3803ac84451mr3932455f8f.6.1729861516074;
        Fri, 25 Oct 2024 06:05:16 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b9216fsm1459852f8f.100.2024.10.25.06.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2024 06:05:15 -0700 (PDT)
Message-ID: <7c1a7b1c-6fbf-4bd9-80d0-d2c3d951e342@redhat.com>
Date: Fri, 25 Oct 2024 15:05:13 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Don't eagerly teardown the vgic on init error
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org,
 Alexander Potapenko <glider@google.com>
References: <20241009183603.3221824-1-maz@kernel.org>
 <3f0918bf-0265-4714-9660-89b75da49859@sirena.org.uk>
 <86ldyd2x7t.wl-maz@kernel.org>
 <eb6e7e29-b0a8-47b1-94c4-f01569aa55cb@sirena.org.uk>
 <92d755af-e19b-49a5-b4df-a8ed0fb7aece@redhat.com>
 <ZxuWIXFJignbcX1m@finisterre.sirena.org.uk>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <ZxuWIXFJignbcX1m@finisterre.sirena.org.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 10/25/24 14:59, Mark Brown wrote:
> On Fri, Oct 25, 2024 at 02:18:02PM +0200, Eric Auger wrote:
>> On 10/25/24 12:54, Mark Brown wrote:
> 
>>> I'm not even sure that's a terrible fix, looking at the changelog I get
>>> the impression the test is deliberately looking to do problematic things
>>> with the goal of making sure that the kernel handles them appropriately.
>>> That's not interacting well with the KVM selftest framework's general
>>> assert early assert often approach but it's a reasonable thing to want
> 
>> Can you elaborate on the "assert early assert often approach". What
>> shall this test rather do according to you?
> 
> In general the KVM selftests are filled with asserts which just
> immediately cause the test to exit with a backtrace.  That's certainly
> an approach that can be taken with testsuites, but it does make things
> very fagile.  This means that if the test is deliberately doing
> something which is liable to cause errors and put the VM in a bad state
> then it seems relatively likely that some part of a partial cleanup will
> run into a spurious error caused by the earlier testing putting the VM
> in an error state.
OK I better understand now. Thank you for the clarification.
> 
>> I am OoO next week but I can have a look afterwards. On which machine is
>> it failing?
> 
> It was failing on a wide range of arm64 machines, I think every one I
> test (which would track with the change being very generic).

Yes I can reproduce on my end.

Thanks

Eric

