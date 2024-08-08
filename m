Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8753398E
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 19:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723147123; cv=none; b=Vp/LRwcD5htRlwx67LVFEB+jIdqOmIzOTp3WN+4P/RQ+9+CqijhoIxY6xEM0eWaZ5xS98XRCnFsFK6KR+ZzqMhyTSJG+IsivOo7oYXQBTM/LGUMBR6v7sXY5P9LDPrRENvYoFL0t4uMh3yYvCaI1mor5CK+twsQH1c3QiXOH7+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723147123; c=relaxed/simple;
	bh=qhoRELp0nXoI/COuYWXvg+4+/JGWDI6UHeZkQ4j9XoE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=DidB1Fxvgb7IM8AmiKEwieaCAnJVtEv0cxsl7dAT7RnzcwBMyvV+HJ2/wMDUmjAf8RNBAcfvOccxlIK9UQMZwRkQkRXjL+IHMrGcRe/l9bt+Nerjm9ok1/pFBX7YWNHHIECrm8SuBbApcJj4Bx1qWtHlq19wC7/1TkJqb1XU/iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NKQqyn1Y; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKQqyn1Y"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-690404fd230so30007187b3.3
        for <kvmarm@lists.linux.dev>; Thu, 08 Aug 2024 12:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723147119; x=1723751919; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qhoRELp0nXoI/COuYWXvg+4+/JGWDI6UHeZkQ4j9XoE=;
        b=NKQqyn1YlntLNwHenRqIOZszpOZBOONJO7rCfd2tsX5f5EgBqgwAL0NH8Rn0+tUa29
         TimYFC9K16tlGgDBIKz+5aR2FHX99XqGduWSDVePcRHc2+MjZXRCF0Lggoho2k5GJS+m
         udtQRXrMmZcf6IE/XJU9tYq80xX7vwni+9VweisTSguJviYTw1a+CyU/arkhLrc8yoF3
         37eIWRt/3hgl0T3RQu3H8//9b3KV7/2Hg7jxIRb5zTc71ZuzPB3oHxHgZJL4fSbMs1St
         I9a38B8Mgv2qxnRWvuqPF9qCz9eKuLvRFm0xnpUn4l2xTNn52P2hPUcNrcs2qEVM9aA2
         Ub+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723147119; x=1723751919;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qhoRELp0nXoI/COuYWXvg+4+/JGWDI6UHeZkQ4j9XoE=;
        b=P0Alciu7RLOfOvoOyy8ijANG+KLr8F+xFpqCMSHRhHGZW2qUz3ro+D6oR4/zsSUfdd
         3gcGgz/zUPN1L0RAUrwribpZ6Zl9LnniSIoCNe+/ic2luBlVrL7A61tj8mR2NCyxUdny
         x8j/AcsaOe2UT49WnhOlb8yzcX5PzX84MpvVyUa8DiuvZoSEY3tNsM6ytgfdpOzOpG8v
         VWPoCfc4jpEu199izEVjY3Q9FTAFf/gnHRSuo7jQaUaZQFbqRL3t/Ua2/iN4jm3TTkhB
         3nM/2uQAQilCECEgJd3AbYfiHor0uQ6SQ7QegYey1lzz0OeZZn3DdFZ+IDYK548i/iUp
         Awsw==
X-Forwarded-Encrypted: i=1; AJvYcCWo7Q63ZeaX4KtHi5iZ1LjY0kMFgLn8FT+EKwak1BJctrTxEy2vI48LnAUsj/sd0F6eVzhK/cy3hHimQvd85DzLAZla3fnX
X-Gm-Message-State: AOJu0Yyk+vehEL113lU9+JRDYH+xOt9FOmFZfrqXnwt9zdwJPlPQI7oP
	Irn/TkV45kg2DaUZUwrUqwLhlUR9A723wX+TVuDDVzJdTuKJRS1zqPipQmMOUO+u6K15eSLMQWO
	tpNwGZ25bzzFlp8BhtOYdKg==
X-Google-Smtp-Source: AGHT+IEigNweiXDrAdz21J+YdPs1Skcc9+Ege+GZLI1vt28thJN0TK7T9V1VytHT8g9OrCSwhqlqBNlR2BBx3Tt0VQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:3082:b0:66a:764f:e57f with
 SMTP id 00721157ae682-69bfb7e34admr335247b3.7.1723147119376; Thu, 08 Aug 2024
 12:58:39 -0700 (PDT)
Date: Thu, 08 Aug 2024 19:58:38 +0000
In-Reply-To: <ZrUGpZVnUN1NaVga@linux.dev> (message from Oliver Upton on Thu, 8
 Aug 2024 17:55:49 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnted6y23dd.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2] KVM: arm64: Move data barrier to end of split walk
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, ricarkol@google.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Thu, Aug 08, 2024 at 05:42:43PM +0000, Colton Lewis wrote:
>> This DSB guarantees page table updates have been made visible to the
>> hardware table walker. Moving the DSB from stage2_split_walker() to
>> after the walk is finished in kvm_pgtable_stage2_split() results in a
>> roughly 70% reduction in Clear Dirty Log Time in
>> dirty_log_perf_test (modified to use eager page splitting) when using
>> huge pages. This gain holds steady through a range of vcpus
>> used (tested 1-64) and memory used (tested 1-64GB).

> Would you have time to put together a patch for the dirty_log_perf_test
> changes you've made? This would be quite valuable for testing future
> improvements to eager page splitting.

I can do that.

>> This is safe to do because nothing else is using the page tables while
>> they are still being mapped and this is how other page table walkers
>> already function. None of them have a data barrier in the walker
>> itself because relative ordering of table PTEs to table contents comes
>> from the release semantics of stage2_make_pte().

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>

> The diff itself looks good to me, so:

> Acked-by: Oliver Upton <oliver.upton@linux.dev>

> --
> Thanks,
> Oliver
