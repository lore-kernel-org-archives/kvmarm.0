Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF511B7F4
	for <kvmarm@lists.linux.dev>; Sun,  8 Dec 2024 08:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733647790; cv=none; b=H3aSUC1tfsqA5agOY+bNfiJZwNE2SXP0F/Lg3BhpY9hIFHeFFXPK2/WEuu2GNp40uyob+nLZOmBJPG15BMkM63ZjhWGysgURqNJyM++SqnadSLu0owcZtOz563ZoxYMIhkhsFN7wSbgB5QOFFCr0qnwm1N98NLSeozZUdlTOy8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733647790; c=relaxed/simple;
	bh=4qUZxOdGlWFXhXVdk62zj9QIKNrm7MsALvQdgFLmnpc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=d/GCTKKpWRGpZLlMGjvJb2g6EpnOoj4UItdXVXsHuqedt9gc3wJh5bF28MapmT26XyR9eSmWrcBSKhqBz4nwQ7ms2seEDXHfh/yrzFDzVAZibfK9CVhCchEWz96hYMW0nEOYdq2c/xdga3WxZFwR7ufEyXO6+7dbZWx2Xh4JAII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KPXY/fM1; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KPXY/fM1"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7fd455ed70eso240269a12.1
        for <kvmarm@lists.linux.dev>; Sun, 08 Dec 2024 00:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733647788; x=1734252588; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4qUZxOdGlWFXhXVdk62zj9QIKNrm7MsALvQdgFLmnpc=;
        b=KPXY/fM1zKTn+Cd8Trbk5jA6ImQRE+aNFUOEXASWRla9kEycBR8jFgd7oGQjMnsS9+
         PTaMITvGJmuCmFFcNtEnRS+GoHPIUmMlM0Obc+J6Orq1L89Eby0RJYFtEjfif22xD1fX
         57xo5/KrAOd1TuBk9pOCR3R0VTuZtZUMeC3HnKuROk7jJUBV/iMlP3NyDaqR25vSeTTy
         vL0IzTW3ytnczLNjOGzJBWVQSjihRFXnhOuMxF17yXDdbQHQMKrQZmw8nGQjSUB6g+P8
         T2enq+Hh7UmK2Ktbzu70nhXUEGWsHiAfGB82FI8opZHi2Y0aRa8ucINTyHtFha1muEJk
         WVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733647788; x=1734252588;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4qUZxOdGlWFXhXVdk62zj9QIKNrm7MsALvQdgFLmnpc=;
        b=o4u9xmOYCNXTDnbl1obnz4BpO5DZzq4hcp/p50PKqR/gRlTR37iJ5ibn906JU85xiY
         N9SYH/OYH2Pb5rUWSAMV8p2r5Bqmt0vk5EYC9hWoc4w2PZDA1u0A9MlRLGlRywbvQmiw
         mzoyz9jFhKcGrrhQ8KUFfyUp45DVuR0h4l9ueBYWTTVCD49pe4xd3h+b7yNDrJDhvvuc
         z7fH0RChyqAoR1C+o4WqVMj1CVBUbesFtEmfvvN1esUzUh0+DkqeVknwv4xLvYSrdpAq
         a2knElSh9GCC1AppI1FQUIG1sgM0xEkwkfMG7yiNhmPLJPpKLP2g9cNKcOi5+ugrIhT2
         wh5g==
X-Gm-Message-State: AOJu0Yx51qmpay9sp7V7K2P8VTm3pm134q7RVnQPSPFmXVbA/XRwpsFN
	ZRBU84sRVvyAiSEKPpPJ+pMokaXq6SI6fPmerOrjqDyu87wSDGVaZevwiB0SEP8GjsmVM4jIusE
	FkxxHvZUf3LdSFKNRLL7z0KSrkY1ekqn+1YXyBQ==
X-Gm-Gg: ASbGncun4LNhSltyMoFMhup8maQo5EK+5BF8+0s28NNpG0xaiIBjlLHr8vE0JuKcM9n
	7Or1dNk0nfEab4fmOXIn6sBfhXADppJGEYBk8
X-Google-Smtp-Source: AGHT+IF97m54KcpoXMoRhqvT9CTM4tUjKkR9lDBTjvFv/d1Ho552kL3o24Ro+SecRgcw/6EssTlHCcNX6UmkjtKejEY=
X-Received: by 2002:a17:903:11c8:b0:215:65f3:27f2 with SMTP id
 d9443c01a7336-21614d1f236mr125967925ad.8.1733647787902; Sun, 08 Dec 2024
 00:49:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: =?UTF-8?B?5p2O56GV?= <shilishuoya@gmail.com>
Date: Sun, 8 Dec 2024 16:49:37 +0800
Message-ID: <CADTb_0OACnCHNyot1VtqoVdy-92VCaWBLtMnYdVG-31R+oPgpA@mail.gmail.com>
Subject: to learn some kvm development knowledge
To: kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

subscribe kvmarm@lists.linux.dev
