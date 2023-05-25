Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D441FC05
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 19:26:03 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-564f6099813so1360147b3.2
        for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 12:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685042762; x=1687634762;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6Gt90zOwJ9mi5eHlnv2jnI0ySmjYJ4m1WS/nV2KiYm0=;
        b=xckIqZevWkLNFYjYVIxqvOArlpXTXa4Rn+4hryPquh3h+fqnBRh11PbOzFWkQqTVxr
         YKTrsk4LdsZOQNB5161ZN7r+8G26/0am4FNkfUNnHLj4I82tsM0bIQW7BqK17N4lpP1A
         juINJUIkMnkyF11/akp0KAQz+FOQVu+tdKvmOs48FBPnthJUyG27gjE3N08KUAvZddh6
         U6Ud/NZnyBNJmr5szv7MgCwisGD/M2xNvVOrFmVNa7fELo+a7rOq2FY1nx6VmdO98r14
         Kd0l5DSs9cvvb6kM73b1KVDcwCfry5cytfwHsLat+ISriw2LmWumooGaDBKsNcB+EvRR
         BFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685042762; x=1687634762;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Gt90zOwJ9mi5eHlnv2jnI0ySmjYJ4m1WS/nV2KiYm0=;
        b=hjdAHb6iTtQ3je6J+7Vl2CX3299zH9cD7SInsjrH0huH5gCeta5T6ZkM3E9TltcCbj
         n5W5famsxh4X7Q+n+5P0TX+zDpIic0+F882nMk3JPj9TyDCMGkqqQkTOj9knnQpxD1mk
         tlEVG9m8Zly8OUC5s2lMiW96WNPYmeUk/HxLdVZZFGuphcutVtOmoTCZQHxkXFvfnQYp
         m0Gz063JLwJYnO7hmof9urBB2YVoR+TkVnAnGP0IgQWeeEas6rCYNfC7R+xq70Kwc80C
         i16UM9YLd6jNfy0/Vi84ohVEM+ok8AJ3h26Gd6ODC6hNbBBLdw9XNEQHpni0dCpZ0XPJ
         PxLg==
X-Gm-Message-State: AC+VfDyTLM7UYHA9zFtt7WCaZ/glp3HSKdW0f/B9o7ZQ4rGXETUYkVLj
	4fHtaeN9jBCZV3vtd6znypSHpEowPP6gDU+kCw==
X-Google-Smtp-Source: ACHHUZ4uH5AqfAW158utnpLgI3U+J0T8My2BfvrDS2VXq1pyjhZTgWuSJAqcH/fLYDWyCXakupT40XwCiknFplrL1w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:b1c6:0:b0:559:e97a:cb21 with SMTP
 id p189-20020a81b1c6000000b00559e97acb21mr346190ywh.9.1685042762258; Thu, 25
 May 2023 12:26:02 -0700 (PDT)
Date: Thu, 25 May 2023 19:26:01 +0000
In-Reply-To: <20230509142235.3284028-7-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntcz2ob4c6.fsf@coltonlewis-kvm.c.googlers.com>
Subject: RE: [PATCH v2 06/11] KVM: arm64: hide MOPS from guests
From: Colton Lewis <coltonlewis@google.com>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, 
	Luis Machado <luis.machado@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

> As FEAT_MOPS is not supported in guests yet, hide it from the ID
> registers for guests.

> The MOPS instructions are UNDEFINED in guests as HCRX_EL2.MSCEn is not
> set in HCRX_GUEST_FLAGS, and will take an exception to EL1 if executed.

For my benefit, could you please explain why no support for guests yet?
Why not set HCRX_EL2.MSCEn in this series?
