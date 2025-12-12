Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B90310652
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 20:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765571403; cv=none; b=lGGWK2NBe59V30F7Wjf+bg5JRauj4LcyW71ETvpUQloFuQwquMy5YuGJSQsCY4SSbKLgPkTGFMm/w6tqnauPCPolN0nUEsJAgWaPj5XNiYfWV748hR55moA7yu0QUdZizpksXD8pAzZs3sFLqBL48GFckKrmqu7HOi5rgkkE6LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765571403; c=relaxed/simple;
	bh=ovPDDBDay26a3+eGDiFu4QvB1wANKfFVQsCpr8lljp0=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=mCjE3x5XQNq8pzTaI5H8gY55L0dthCJb4I9zeQPeVdIeATER102LltTprac95pvBiNNi4Y40l1P93T0yFlsze9PYKumFDBXG+8AVx1Nyp/UNsnAPfZUkqCQ0p24F0IneZloS5f9guIar12MCxkov9o/NvAHa9WL/xaHH3Dp8+Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mrtJh8d0; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mrtJh8d0"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-3f4bc7318aeso1277754fac.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 12:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765571401; x=1766176201; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IMNyF6rnk7IasEWeVI8MWH21McRpJbckeB5bd8oSwWI=;
        b=mrtJh8d0eX6lTgJHDX2elrtUivePFC4AH0SBBRJgF/LkBlwo99yX1A2cJVu2s6w1Wz
         /vstHfYOD3A+E8qXEN74WBkZHT57q1pfrEzYR6ro4mbezuMqDFzI6Z2zIzBWREoltSyC
         KYCcO2Gds/lyvio03hpjabRTInRUwWinoOcByHFKPOq3GSW1gCR7r97sLwSRcWWQnph+
         7JqHkTuNAsA7uuFdhoZcwUZuJATB9rPso2izzDoU5yw4wSFF+b++PjzA08hIucLV9kDI
         GsXBj3F3x/wMc7/0C+tqRC1KxiwCqslB/YBQ9bcaUXMQ5bMD4k4EY2ASnXiZaozL7USl
         cIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765571401; x=1766176201;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMNyF6rnk7IasEWeVI8MWH21McRpJbckeB5bd8oSwWI=;
        b=l7aO9K2BdKxZtpCACE+7B8Nl/rneFR14DOL9zNSkJkrtLZhGFIfqfiHjdXVj7ker5D
         qfYBgJXIAhshZwEaGEAfBV52uQr2yF45HM4ETfL4rMS10KAb9t+mAlT5yCUWXr1ewmXF
         KgIi/tb0rfQKqiB362QaXbEOdFHd2uHaEK6vjd8H9/+ie6RvkhnSCs8ZReoNmFUYTZ4G
         6ZF/ci83sp/W/aRUGFeck8qIyyP9JDAXCxyRLuTPW2xhliXWv9zkTArdVtdGzsEqb8il
         hV3+AT+E1nQ/9bzio7tHGp5hfV0dne0KdHzK8jBMspE7uK3hXbJMsSGeOyWrZsWtaVCG
         udow==
X-Forwarded-Encrypted: i=1; AJvYcCViIU7qz8V1MGhPasZaZB9mNM6tAHrEnJliBB3ePRLnAp2IGQZi3DYzG1iRUA0IFId52UC6JdY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPwQeNItbxwyWFm4TdCaP8dMMGZXs0D1Gx0M4tB15ZuEQbX2ZI
	kgcQI3NNb+Qg6G+BtB1Vok9jLxs3q8ZgawXmHiDdXrlWZAPzehj+DGyGGNiRuAkVNlwwQtnr1p2
	XmLE7vT2I+wFrCgcIr1iMIlZ2Gg==
X-Google-Smtp-Source: AGHT+IHCc2P1hnQfNfNIerRNuvTcLdQFAWD/TzzhCNvUPfhQTb3KYPRTL0VnqSzv7pNym78BlH1sW72DFgyhEDe6qA==
X-Received: from ilbbn5.prod.google.com ([2002:a05:6e02:3385:b0:438:15d1:5e1c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:178c:b0:659:9a49:90bf with SMTP id 006d021491bc7-65b451e95f7mr1599664eaf.62.1765571400768;
 Fri, 12 Dec 2025 12:30:00 -0800 (PST)
Date: Fri, 12 Dec 2025 20:29:59 +0000
In-Reply-To: <202512110439.UXwb1Qh4-lkp@intel.com> (message from kernel test
 robot on Thu, 11 Dec 2025 04:21:58 +0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt1pkz4f5k.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 09/24] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: kernel test robot <lkp@intel.com>
Cc: kvm@vger.kernel.org, oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, skhan@linuxfoundation.org, 
	gankulkarni@os.amperecomputing.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

kernel test robot <lkp@intel.com> writes:

> Hi Colton,

> kernel test robot noticed the following build warnings:

> [auto build test WARNING on ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d]

> url:     
> https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20251210-055309
> base:   ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
> patch link:     
> https://lore.kernel.org/r/20251209205121.1871534-10-coltonlewis%40google.com
> patch subject: [PATCH v5 09/24] perf: arm_pmuv3: Keep out of guest  
> counter partition
> config: arm64-defconfig  
> (https://download.01.org/0day-ci/archive/20251211/202512110439.UXwb1Qh4-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build):  
> (https://download.01.org/0day-ci/archive/20251211/202512110439.UXwb1Qh4-lkp@intel.com/reproduce)

> If you fix the issue in a separate patch/commit (i.e. not just a new  
> version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes:  
> https://lore.kernel.org/oe-kbuild-all/202512110439.UXwb1Qh4-lkp@intel.com/

> All warnings (new ones prefixed by >>):

>>> Warning: arch/arm64/kvm/pmu-direct.c:75 function parameter 'pmu' not  
>>> described in 'kvm_pmu_guest_counter_mask'

Just a missing argument description in the comment. Fixed


> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
