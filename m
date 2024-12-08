Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506FD9461
	for <kvmarm@lists.linux.dev>; Sun,  8 Dec 2024 09:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733649089; cv=none; b=IO8otfj/C3HBJQKw9/lU5ogl2h8RJJPTfnJvmogpw+NFcnUMRu1dKGpV9Ji6UX17h30P/Mww5fqE4+f6DQjgNcnUkNCmModqR9cc3RV3t0uC3wOWiOxM/JYaeva7ULvNuWWkH/dcghmOYV0F43qIqj5KTsDLYVkmxVAkPK/fpXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733649089; c=relaxed/simple;
	bh=bO05SnqFtUiNZGIvMfxRQ1SNB/6fmbFYF50rx4Jwc5A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=WEZ2DCU6E149/mxON+MhkXnW32qOodJwiYtY2qVAQDVGzOLjhgbsgaxB6z7PG0SQiMBsgnHpHP0cRhBgTqjUkQxaP/mddySrvHhtxEvSrxwGYk6wjTBHbufKHyjMCeUWuuLj4JtxYbuB+IffrZ+SqLiL+4IwO7EfLqOOJC3yMuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UzSilIFI; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzSilIFI"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2163b0c09afso3730475ad.0
        for <kvmarm@lists.linux.dev>; Sun, 08 Dec 2024 01:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733649086; x=1734253886; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bO05SnqFtUiNZGIvMfxRQ1SNB/6fmbFYF50rx4Jwc5A=;
        b=UzSilIFIcKF2r42N0aphlOym0BKsN8u7kJQAUli/ZUrJmauznMTHOaG3UcVLBfCJjC
         wlmjKcmxl2b15K+2RXHRTO5XUK/wSI3UGS6hLjfcvDu14UE04/JYQ8eoyzwGBln98rLh
         DXOZYFyevuiUpSB4NeDG68wovziQKp3D3ydXnk2MRwoTaBfiP/hhV03nbiij6bkzQTHt
         6y2xrQEVUUdySj3I4eXwsKDUAJmu0GE2IguhPeVuEnoOVN24IgFtJ7W3Fc7tE/LFR7GG
         TAnPf8NywJPkvq0b5e5/L2Q38nY5a5A7/worb3bQGwhDnNL7JHyPnk0EikWMvEd3Ytn3
         kD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733649086; x=1734253886;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bO05SnqFtUiNZGIvMfxRQ1SNB/6fmbFYF50rx4Jwc5A=;
        b=n3KXs1gRoiN2c+7Fr/3mtEL0oJL0vYOVGfvK9Y0HzkPibyCJSK/fjd7s2WDfgyhY7P
         Q/Vxp47/Ou1nY1zom9qFAPFYyvu9LDShkRq+dGxjQQy8gp8Sqv7xVo/TT6VMZSpUOse4
         gpug+uc691L15qc86zroY0VPAGyE5H2Hb6ouIWrowHAkV2/RVbzn2zKjuuRM39wLx/A0
         SdW7461/U4eamQ4BhdbS/4nGVq0g68+amMPRV/S2iVIaiFg7/QbWC2EXnhPa92NJXP2X
         Z96MEeQTdo5VDpxMsreuXAu17dzmtc/R3tUalaQ36+wYRPUh2jSYFc44hLx1iIdmVNjA
         hdjg==
X-Gm-Message-State: AOJu0YyPSUqwCra3NdPRu3XxFi+kTM+InecOMV4k2OKXXL5k5kSPlQn0
	YTukwJ8X5CaxUQ73hE+6F4e3f/nX9cdeP9cXdYwClP2JaDZnEj59FC4rGrWEXDrLflQ3ndeTGzP
	01uvvBUOkwMbfLssYHMKHckHMeH7VxmahfFe5XQ==
X-Gm-Gg: ASbGncuTWaQE/OBWIWTfSYYr7Y4yRAivhOjM3AxLFP2tfwhOCppBUqWo634pQJuPP+i
	jUvYxhxsAq8P2nkYCPW528CTgBu0GcoMVZR4z
X-Google-Smtp-Source: AGHT+IGVCvpm05aAlGm83xn6DMkvOwO35zFoap8Uuvhmba6pH47XfLCyBEbtAGdPw9WYV/F4yJEG5IywiDc6afEZzhk=
X-Received: by 2002:a17:903:2344:b0:215:b6f5:dd2c with SMTP id
 d9443c01a7336-21614da2f2amr121904235ad.43.1733649086039; Sun, 08 Dec 2024
 01:11:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: =?UTF-8?B?5p2O56GV?= <shilishuoya@gmail.com>
Date: Sun, 8 Dec 2024 17:11:15 +0800
Message-ID: <CADTb_0MHZnoRLdCRp8VgCPGLmOOeOP9gd1Xtfr-KQ4UN3CMZmg@mail.gmail.com>
Subject: subscribe mailing list to learn recent kvm development, not robot
To: kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

subscribe kvmarm shilishuoya@gmail.com
