Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4549620
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 13:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748005532; cv=none; b=GzbI41fFcG8+ua4OCXIW1paK4xrF7KpxO9nKE0cvcQfrfjqKpGExpt+cCPaybgGztfuMN36/AcGbwvRKC1yVJbS0juWaGytjiHfwO8jKTI7va9noV8JoTpzSGivtmGTBdaFi6MqB9NXnzrBwqd8MZFxArfVQpu12ayxoPI8Xg8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748005532; c=relaxed/simple;
	bh=eBKAm2AJciIUpLbPQOmLAQPNygq8Ocm2Eml3M6OpgbU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Scdr0RVwFcs8j7DgFhFep2c95/o5QXBRoxEcgxEp/kVGJGXzNhw8XZMa1hCzmIqnHOfF2EbRovatq60WtakHcBZXbLS/CkFuNVlbrB6h2dxIZy7/4MH0Ons4MnQxvCf3j3b5KZAedS9tUo6ZuEpVO5KAgnTw4V+h2PPWvnR4JVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=awGPfw8X; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="awGPfw8X"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cfdc2c8c9so56144015e9.2
        for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 06:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748005529; x=1748610329; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kuI3B9kxX1Iq6NEwiLbLt18bZ814ygZMl/v7N70dy3g=;
        b=awGPfw8XYwvaF4eNcXsaPwEpYH9zGa2PRqS8EFLyKi1Jyy0YhCtO7gELEp9X2tU+XT
         FlIymkNykc1mph+/UpJA0j9+Fjua5c96mLKPAsFZYUuGzo4qfIqM91zK50KzDMbpzG+f
         lJzdrkEhazXq/xEeW9TdKR4s/Gn4P6UMHvr0b3cyQl6UNlTmhxJKLw2pzvws3So8mO7q
         Yx5cbzJlgSsrjn9cnj5f+x0w+yrUfrI1+pLIyPyCitsbvx/n/zoCLyEGQhbqeXopfciQ
         PdTbJlVBLnR8Nhl7wPHYzqRoHSSp9CG7OXuf2BfBVeeXXnwZoBTi7w/21eDFqUPeMJLG
         tEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748005529; x=1748610329;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kuI3B9kxX1Iq6NEwiLbLt18bZ814ygZMl/v7N70dy3g=;
        b=m14bEBo3PftACD5CTt84WBAHM6iAS1JNll1Hp8WQB1R2t3vXWrP4VWMcRU/pALnIFa
         jOl/xXsrcANj9AWjC7x3EgRfuGw3IJwWDhUidDSv4Mv45GdWV3rMyiOuw9qDqiSQz95x
         4IUkgepuzcTNEzGkv68kaF3VBrg6ozb2hn8HjCPDel6I8iF0PnWWh/sKbwVOjpPshzd9
         JBa/jMsDVnYDOEzdPAEwutVHfmUaCoFpy8QZ5mY5RuUOoUvMtgsJbo3D9HnAX+x2EYd2
         foXio5QiXJHKWfMW+OEFso+glE2prnf7B0Aez9qsjCvqAGug7fGmqPA/W0s5SqWNvzwz
         m4Gw==
X-Gm-Message-State: AOJu0YzdxBOBdLXdW4udvCkNdJYZCyS2MH2fVJZ9o6LVmUR/XzG4fh+S
	pWndWUf/5DueFJGDMA4sVT9PyPCUSzsDQPgvV+D4rOWf2zRpXMs6FgKNa66k/dLLTsU=
X-Gm-Gg: ASbGnctiJICSrXzfX1Ddmxz62tc0vnr2OfF3SwVix6lFVKRmr+JjuMDumoYgbB8H9VT
	VKHeZVRnPgo27jT4NK3P7d4omHxYxSYp5dSeQ6yY7TG+aU/wuN0ZC8zbcACL15rRKLAQeotd7H3
	+C7xyBXBYiGPjx4pb5a1csecMxXv1kgDVX1BHm78tSVkAh9rSr1ETn83xvT+fVWmHDBLp5hSXj+
	+Ec/edKmGpnRPUMWBLAwiQnIsOrDv7XYpl9kRVCYjHJjJopN2J10zbbIrJJdRKb41Sxra834tsA
	C0+gmClUSqvpUlXIjMsVK3PUrywDeJLgGNdSCV3qEs7PF8FgnpON4cQT
X-Google-Smtp-Source: AGHT+IEqDH1CWQYUcy5XHxM3u6T+x8FZEAV0ii/i/tIa0TrGB4czeYzSNwQjjT9Ou/Jf7clYm3EGeA==
X-Received: by 2002:a05:600c:548c:b0:43d:fa58:700e with SMTP id 5b1f17b1804b1-442fd6759c0mr239671525e9.33.1748005528715;
        Fri, 23 May 2025 06:05:28 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-447f38142aasm137416885e9.27.2025.05.23.06.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 06:05:28 -0700 (PDT)
Date: Fri, 23 May 2025 16:05:24 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jing Zhang <jingzhangos@google.com>
Cc: kvmarm@lists.linux.dev
Subject: [bug report] KVM: arm64: vgic-its: Add debugfs interface to expose
 ITS tables
Message-ID: <aDBylI1YnjPatAbr@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jing Zhang,

This is a semi-automatic email about new static checker warnings.

Commit 30deb51a677b ("KVM: arm64: vgic-its: Add debugfs interface to
expose ITS tables") from Feb 20, 2025, leads to the following Smatch
complaint:

    arch/arm64/kvm/vgic/vgic-debug.c:501 vgic_its_debug_show()
    warn: variable dereferenced before check 'ite' (see line 493)

arch/arm64/kvm/vgic/vgic-debug.c
   492	
   493		if (list_is_first(&ite->ite_list, &dev->itt_head)) {
                                   ^^^^^^^^^^^^^
This dereferences "ite"

   494			seq_printf(s, "\n");
   495			seq_printf(s, "Device ID: 0x%x, Event ID Range: [0 - %llu]\n",
   496				   dev->device_id, BIT_ULL(dev->num_eventid_bits) - 1);
   497			seq_printf(s, "EVENT_ID    INTID  HWINTID   TARGET   COL_ID HW\n");
   498			seq_printf(s, "-----------------------------------------------\n");
   499		}
   500	
   501		if (ite && ite->irq && ite->collection) {
                    ^^^
So this check is too late.

   502			seq_printf(s, "%8u %8u %8u %8u %8u %2d\n",
   503				   ite->event_id, ite->irq->intid, ite->irq->hwintid,

regards,
dan carpenter
