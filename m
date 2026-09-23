Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6D46D544
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 08:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790152738; cv=none; b=WcTUaOb6BldeHcYtnJLe9D9VfLcKGlPnDLeSYlsp4tdqS35UXSnviGNzNg17ALqQY48HZQ4L//DB1Swr48ouKtTYZ9eoKtpUPZaPBotFIx5hRV0S0xEvHse9UOEo0Phrxom2U5dL6KfrQL+SA/y9gLmN22MwaEPmAiyyJdjiUQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790152738; c=relaxed/simple;
	bh=oSQ+Mq6A5TscODmoyrIVu6iJjtgM1iNvQM6RlsRFikE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e01s4YNN6MYyCCY+qyJjPdPKuAyaBj6UAF6x2HYbKLDzqCkSRfpnFw44NDwE6jG2Zpmxnt61LRkuWRUJHoLcTGK2KdxchItLFxd3v4pMxctD+royke8vFOpL8FR21Mq/jQTGEyeaEOokaDZ8lKZNE9BWlmIXwSHt2Z7CCVLVR/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KcwgAeHe; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KcwgAeHe"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a9b7c8f4afso716886a12.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 01:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790152719; x=1790757519; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/rrd89OsQ/qKLyQdREPNPgMGcGQacoElL1Au38Xxqk8=;
        b=KcwgAeHelc05fe/zlXFlVZGUsN4vT7DdkuF2elQvi+Jo4/RJ93KOSV3O2sfMkHSGYs
         RfWaKYsgVfNOb4oHLSuzMT8s45GhPNHC27cN7uU/HfUPwzDNe9jQNbVYJobDRbMKUmr2
         q6I5qosE1M1N34wfMZ99FMJKzv57UAKn1gh3xe8hVCRCNs2e5lGfNlnsOyVMkTtU8nbQ
         HyzflyjNN1LVm+nmcduwHSRncXoGC8ZkuW3HF+zChWDQv/EkC4sOCpnw+dzhMRSilu3U
         M9C4RoGtWBcIjJ0nuQiU0z/khcqqUj/BFiicM7uRd5t8/YU8NK9W7knImk6PpWycuyDp
         E/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790152719; x=1790757519;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/rrd89OsQ/qKLyQdREPNPgMGcGQacoElL1Au38Xxqk8=;
        b=W7Fyr6W8xiuGEMfB5J/BfGw0VGe1rOPk4XVA1aA2WK3znqqgPEtOihFxgTWtW6TTFe
         rSI54rMqddZwHSITfMIJjYlMd/vYyX2CBPsWr2Bzxw8Pc0qzER9f0g+kJbDvrKgWte/x
         oOT9D2BU+8KeQe0468c4TquTaBM4m53Jo5rHdYkr55QSyE0YSBx1sRO8OLbG9Hp42mv9
         H9sn1zxUGWRoTmMxG4FJNt+S4qtT7XVpgHmsASgjUEojLFi4IELYn09zkn7y5XdssvvF
         3hLkSJ7a0vvEk7NbG/9HX7cHNqI93CLOqAiQUxhxXtJYLnnq69vzvEcs0ovm95+2dozI
         FVwA==
X-Forwarded-Encrypted: i=1; AKwUvByrCj5tHjDBT3LV9o+ifjpK3TXyS2amb3AMoZbA2ML3PzrnYWw1+i9r/X554PxAM4GxSPQXsh8=@lists.linux.dev
X-Gm-Message-State: AFuF++mnlGCEOh5vn55mZD7rLmtYdjgjDmozi6ITbgvJf+RQzu6JHV7C
	7ekZ96PSNr4FXlQbvEXT5NhJAQf8/rc7C+q/xvcRApNUavwzU4kfb43OqUxyIVR52DU9Z4oS71D
	U9ntbVhDJKTptG7Pgyniohv6yeQ==
X-Received: from edxs16.prod.google.com ([2002:a05:6402:1650:b0:6aa:12fd:fc3b])
 (user=snehalreddy job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:23c7:b0:6aa:9fd4:987a with SMTP id 4fb4d7f45d1cf-6aab3b985dcmr1498844a12.20.1790152719283;
 Wed, 23 Sep 2026 01:38:39 -0700 (PDT)
Date: Wed, 23 Sep 2026 08:38:37 +0000
In-Reply-To: <20260922-chubby-cicada-of-exercise-bbb429@sudeepholla>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922-chubby-cicada-of-exercise-bbb429@sudeepholla>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260923083837.4133676-1-snehalreddy@google.com>
Subject: Re: [PATCH 1/2] firmware: arm_ffa: Add FFA_FN64_MEM_RECLAIM2 function ID
From: Snehal Koukuntla <snehalreddy@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Snehal Koukuntla <snehalreddy@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sudeep,

On Tue, Sep 22, 2026 at 01:15:52PM +0100, Sudeep Holla wrote:
> On Mon, Sep 21, 2026 at 04:47:47PM +0000, Snehal Koukuntla wrote:
> > FF-A v1.3 ALP5 (DEN0140 rev J) introduces the optional FFA_MEM_RECLAIM2
> > (0xC4000091) ABI, which enables an Owner to reclaim exclusive access to
> > a subset of pages of a memory region without requiring the Relayer to
> > maintain intermediate transaction state.
> > 
> > Add the FFA_FN64_MEM_RECLAIM2 function ID definition to arm_ffa.h.
> > 
> 
> Since the spec is still at ALPHA, I suggest to add RFC in the subject
> if you post newer version so that it is *NOT* considered for merging
> until spec reaches *BETA*.

Makes sense, I will mark v2 with [RFC PATCH v2] in the subject.

Thanks,
Snehal
