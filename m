Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B4339A8
	for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753455564; cv=none; b=PWH2hgFXnKy53HWebrgqJEbVb1jIFK0oAAuXjenGHA3sk78+cObJ9hqQ3S16wDy0iEZCCNb0aZDIwD7aaOnGjzjGfUrmSBFhhDpM4Xv3v4l3pkp3h5r9v7YaOUIDr4TK3yL20ewHeuthWIjlukJVMgomzPCLrKuTKuHkNzsVoHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753455564; c=relaxed/simple;
	bh=ixKJZ131X7DLb/fIFlcMTloGWlC/AIvG/UdPHPhgJag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X7T7HBcErj/Gc4E62T2F5gfI4WLfaj2KuUCMrI+E+HiUtMzFTV5cPfdIENH5DHEIhVbrHb9d2t9Nk6jsIc6kRbJa6cPrU8qpKupydJzz7oLhRQYFGG/znDoBJbEiONFkidnToczyDJBI9dbrGrrNbvrGJonamxUYaoESlGBMnKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CAkXp4Ah; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CAkXp4Ah"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-237f8d64263so22634305ad.1
        for <kvmarm@lists.linux.dev>; Fri, 25 Jul 2025 07:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753455563; x=1754060363; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRIpv6z9xuIyFwnKQ1z6FnAeGn2PYDaQhA6EKMmoaPM=;
        b=CAkXp4AhzLFwMBfrm/4c1xMZyJIKtScmntlrLm3XvuObtwvgNHRnFjHbuRT59m46lW
         jWN4OboH0sV12X9EUuEyztcXAIF3SWRMhvi/PEmO3HLj0vxRu7yaFyrxc14J0xp94RVk
         4FEA/FO5lOrzvsZWSQ6Kir5/WnsGt1vcUv/4HDjEdwFbChZk85tf/tivYUJoRFxnNlR7
         9uwDwxpmvjIWSo/YR8wJkhqkzGNevXGbQCmfxCjaq4Hw2w9n5XqJ7bUiwmA9fg/7O1+p
         IxbC8sMxqRpchWuwTmG66yCI6OzBvU4SITLXovZnsyzqVv9GkS6mCwG5QwP3ZApWyBs8
         QXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455563; x=1754060363;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRIpv6z9xuIyFwnKQ1z6FnAeGn2PYDaQhA6EKMmoaPM=;
        b=IlmtfNn06K6pedgcz1ZWzoCTsuz5RjPBnCibD8tHXZhzeVLrkouVpq9i14iV6WnjhR
         YOn1azci4AvJEbYCE71Prpum6xf91UAVOCBi36kT6s1jL2RuFxFvLM9iYK+f4ajXHdro
         /yh634bN/K/+ce8c0LT/cRIR1ENKJnXRLSfiEtZ2U/ZYG/It8yED6ys9a/GA9H8nIeLx
         zw8Dv+UyGrhAPBUFYfpndkvgZR7tyeiM96f0IcdX2Jhr87sx5kHDv7dffD++A0VPIvpB
         /D9DAPwWpT6H5mlgGr/yursS2gBeUVkt4QgNVmJpV63SgRSykxBXdiJUk6vAcQiUBRZj
         kPNA==
X-Forwarded-Encrypted: i=1; AJvYcCXwk9+fNIAYh7nVcXhIlk6/QetFrrm20Hmkt+uhi5/5MPM0jrPwlISaaUwsnQORkYkkt1oCY+M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqEnrrGmbftVfubaF8iyOFfvW8IExmNMAp+8jeO139EDrdxIle
	FEpuvOgXs6TYrLWC3O780jt9B8N8uB3OiU6i81PTuUEdbcodBuBmtEI7Iyrlj99AqOAsUSwl8//
	0PmxHYA==
X-Google-Smtp-Source: AGHT+IGcNpmnHIDt5vuDnKz4Z5PQxOcekjZoRgAfUDL4gv7HZdu2LOA9zo/e7zk1ZSljYpL2Zb35pa8dzKg=
X-Received: from plbmf3.prod.google.com ([2002:a17:902:fc83:b0:235:160a:76e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c1:b0:235:e8da:8d6
 with SMTP id d9443c01a7336-23fb3050a7cmr38030205ad.2.1753455562745; Fri, 25
 Jul 2025 07:59:22 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:59:21 -0700
In-Reply-To: <20250724235144.2428795-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com> <20250724235144.2428795-3-rananta@google.com>
Message-ID: <aIObyUg77Um6VB45@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table periodically
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Heh, without full conext, the shortlog reads like "destroy stage-2 page tables
from time to time".  Something like this would be more appropriate:

  KVM: arm64: Reschedule as needed when destroying stage-2 page-tables
