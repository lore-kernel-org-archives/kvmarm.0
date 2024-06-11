Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9A2178381
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 10:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718102327; cv=none; b=Pbu3jLOfiDztT7U81lIypuW9hVr7L27DZLyntVfKqjHnrelOONfKvW+wYfGXEjaTkFmkXWLbiHtgdZI2xQB6rASsdr1SZb5z0uqA4vTqja/cIUf0fBIR5JVSsTHRBkRHaX/ytDN2UOmBw0/MmpEl4NvE2nPjCvxvfQ4eykOdep0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718102327; c=relaxed/simple;
	bh=LpVxpVVK9dZ9VsGBtZI3gqo7kMi2srf+dwknjVIo3Ek=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mcwreJOP+OXnQ5jjk4uFriD7fbizQc0BUwflI39Z290CCQzEnDBy2KlJBe+DlPvAibO6dunYpf99zoy7SqUrLLnKdidnhzDvFfedQALG5T9g/9wnqXvE5SMcOc37odidzx2OqC7Jq23or1q8MNzA8KD9EbYZs3l8hbolsHIN/X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YJfaEyfs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YJfaEyfs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718102325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LpVxpVVK9dZ9VsGBtZI3gqo7kMi2srf+dwknjVIo3Ek=;
	b=YJfaEyfsXBE4J4bvJeCJn5iOJtYwaJ13naOnln5JcrhWfvBDZ7LGlFugzVOpnM89+mJr0L
	6uuOI676RdbmXlA1h6z+OJaGm2GdJS+GUEF/PDYNGqyBSq8uOdUf+z9PeJUIxo+UMdjFzI
	iI8AsoRdhBFjgk2aEnYPIQF1Bf4oMn0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-ikLXS_0OOJS3PUxH9wdTiA-1; Tue, 11 Jun 2024 06:38:44 -0400
X-MC-Unique: ikLXS_0OOJS3PUxH9wdTiA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-79551410d15so79006585a.1
        for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 03:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718102323; x=1718707123;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LpVxpVVK9dZ9VsGBtZI3gqo7kMi2srf+dwknjVIo3Ek=;
        b=APazO5nl/LKogw/HYMACH1aYVywgkKHZrKyMS4y5V/j76DFO3hQofPY45O8667uzpy
         y6+yQp6K+1lYALahkeWvyi5ss1Vv+YYfaE5Sc5c5ZakIHngrBpYhbm/TJZSPli03paJW
         ee+Exx4GLuL5LdGAU6/WZkELrlm6HvUpdTYgzFzhZrI8YkIAVckYqdZkOFqNfUMCPWhX
         1VAnXqeC2+9YPDxE6ExKjAcu0eUSiAUD1jsIANNaSk5Le/W5cfq5VgyBxTMVExcWPjLW
         dxDxq+KuKiyWlhk/xD4OoV8exii0AgKBgKeXosL63QEde0Nnq5dPFfwwg3vlprSvzJaL
         wKIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+uAqLOs0p5hN+Y4LL4/zsBLqy2vHptaeDfpxwoCkwG96W4N5eG4AKLTfrgPQ7lS3sXtXvtAeLH5G5u4PoM0oI67EU3xjO
X-Gm-Message-State: AOJu0Yx5ziwxRmcai2rE0tdORpEJcnWpe1Av7w+kVn171EI9F7msaVAc
	YAg5tJQW1F97apl2dlA0eme1/jRjnslHdHb8sBFdcQ1u6BSAI9ikYVSJpbEzkHh7h3HcnOkqPYZ
	ohcfEzmpTn7zfNAsK1vIOoo9QfxLtcxGKJ1cQYtn0cLzAtitXI/P/7g==
X-Received: by 2002:a05:620a:3951:b0:795:4c65:fe39 with SMTP id af79cd13be357-7954c660a0amr1230870585a.58.1718102323407;
        Tue, 11 Jun 2024 03:38:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWH8vSQU7iczW/0/WLKHfejbsoDwghIq9TNpqFLbKxfZBhFgK72IviX2gClBpKbMjxLDGMkA==
X-Received: by 2002:a05:620a:3951:b0:795:4c65:fe39 with SMTP id af79cd13be357-7954c660a0amr1230867885a.58.1718102322807;
        Tue, 11 Jun 2024 03:38:42 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4405daf10a4sm27135961cf.13.2024.06.11.03.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 03:38:42 -0700 (PDT)
Date: Tue, 11 Jun 2024 12:38:37 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org
cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
    James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v4 0/6] KVM: arm64: emulation for CTR_EL0
In-Reply-To: <20240603130507.17597-1-sebott@redhat.com>
Message-ID: <693a8742-c40c-dcb1-6b4a-43798959b10a@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hi Marc, Oliver

anything else I should change here?

Sebastian

