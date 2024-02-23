Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D19D5D75D
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 09:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708681740; cv=none; b=ScXFEdZYaC6BekJ4JA9YJoh/LZCLb1dv5O2NeeWrakP9glgzVDc+Ng+MLNha5/r4qu5uZV9EaFrYJrkamGONhVWFbpEm/JInty7YlipaqyWtrqCy2GTXFA1I6TLaPgM44thBh421c+AMjtEYgrm07OMLI5cFmzDbd5sORZOMxx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708681740; c=relaxed/simple;
	bh=CHQ8ojToVVo2x2nBAVOg3oJvhiLAFfyJ4tNHaOYASYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NOOTAr/zoAqvkxNjwKRcU1Tn1zbQgAlqKZxY6OmeEUeHrmeYzwCVfaX3PkiZ8bPKHWto2Fu5g9S5tIfTWCvE/nu7ccA1ozRMzJU44KniLUzc7X3mBqGTxJyVyb/1J0emZgf77ru15xnnaAjs15x4q34MJZ6fgIG1acOl14LsmNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YZU+Nuks; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YZU+Nuks"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708681738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ny3rlNG4dj3vSMIabxV2MPIzBtaBKbqMGyTxyLeP7EI=;
	b=YZU+Nuks4PqhYq92Vk/DzlCkBFCZl8b8crclotPriJPXIza0XRz4A9cAqYmzqwBvGFvgf+
	v+CDVTFmOl6fpUVj2voQ8xKUbTyfqTWDXsuyA69QEXYq5624jvzqQqbTvVU4N8tCjJ7P+T
	CDb2Lc9MKRq25iCHX4Ypxak2LduRS0c=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-UqGxFovmMnGvnAkLJJsWkA-1; Fri, 23 Feb 2024 04:48:54 -0500
X-MC-Unique: UqGxFovmMnGvnAkLJJsWkA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50e55470b49so935199e87.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 01:48:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708681733; x=1709286533;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ny3rlNG4dj3vSMIabxV2MPIzBtaBKbqMGyTxyLeP7EI=;
        b=djgm1fMd2qVNDAUdMGkKBX6SFhCPyqL+tNFQfCM9TXR1zMwXRq5AFMOK4qDB61YALS
         iI9U4x+9M/qqkIvUYvoNbmYGRmGoZsDA6T4Mpv5Weoaezdf0qGuWqsCoOKkE5iu06zhI
         WOJAUEi6OT8m2KF5rQVT01lmd+jebF/I3093vZ4epqXiuV5zUyoMnHNbA2UmS+T26rvC
         d7oNhVCndaKB/p/7bXM2eyjHNARDs20OAYBwkt+U3m5Bj53Znkdb0qZN655TH8UukEta
         Fa1H65fFiPhpDqPQ12JOSRZd2liy0ZedkI+XlZyysGH+Ivx2yqLxB+Kj6NZ7Tx3YrehB
         +GQg==
X-Forwarded-Encrypted: i=1; AJvYcCUKbfS6FSLaQp5yLUI58KrNcvYeOn56n/L0Y+FxeFaBTTakH8XV5bTl2XpG2QjoboAmA1FK4B0aSeannOxxDiCj6BoGCLg7
X-Gm-Message-State: AOJu0YwDQn8sB4a3Y59lNtoUt27ub2R3by+VTqg122QZUBdc5DfNeIf7
	s1QcG0evuIVqhhE+PzAz4zl2QCPWXeTjGWVRuEgSbAIim5dSdj2tt0B5YeTW+4/CcAq+0cpkGL6
	w/ZSnhJTOslgOXAnwp8U9fhVXt6EQzQQpeLCVIu/VLu5j54XAMWKAJg==
X-Received: by 2002:ac2:4ec3:0:b0:512:bdd3:1539 with SMTP id p3-20020ac24ec3000000b00512bdd31539mr967266lfr.37.1708681733278;
        Fri, 23 Feb 2024 01:48:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGzFi43eAzp8ls1n6lYPSL+WeUvLXTf3gmpGB+Q/29q/XRkCZHV6zgEp+R6GOxjP1qCo1xU5w==
X-Received: by 2002:ac2:4ec3:0:b0:512:bdd3:1539 with SMTP id p3-20020ac24ec3000000b00512bdd31539mr967253lfr.37.1708681732952;
        Fri, 23 Feb 2024 01:48:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p11-20020a05600c468b00b004128812dcb6sm1740881wmo.28.2024.02.23.01.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 01:48:52 -0800 (PST)
Message-ID: <5580a562-b6ac-448d-a8fe-cedc32d33bab@redhat.com>
Date: Fri, 23 Feb 2024 10:48:51 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/8] KVM: mmu: Improve handling of non-refcounted pfns
To: David Stevens <stevensd@chromium.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@gmail.com>,
 Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240221072528.2702048-1-stevensd@google.com>
 <20240221072528.2702048-5-stevensd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20240221072528.2702048-5-stevensd@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 08:25, David Stevens wrote:
> +	/*
> +	 * TODO: Remove the first branch once all callers have been
> +	 * taught to play nice with non-refcounted struct pages.
> +	 */
> +	if (page && !kfp->refcounted_page &&
> +	    !kfp->allow_non_refcounted_struct_page) {
> +		r = -EFAULT;

Is the TODO practical, considering that 32-bit AMD as well as all 
non-TDP x86 do not support non-refcounted pages?

If the field is not going to go away, it's better to point out (in the 
definition of the struct) that some architectures may not have enough 
free space in the PTEs for the required tracking; and then drop the TODO.

> +	} else if (!kfp->refcounted_page &&
> +		   !kfp->guarded_by_mmu_notifier &&
> +		   !allow_unsafe_mappings) {
> +		r = -EFAULT;

Why is allow_unsafe_mappings desirable at all?

None of this is worth a respin, it can be fixed when applying.

Paolo

