Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2198A1DB365
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733164261; cv=none; b=c0RDGbYWn4Yb3uMTDUBP3oIlBtYa1ILnuVlKgpGXPSfJfFsAWxRZY8gMy+u9FUoQLAbbwsMJu72/4hrU1hKmU+bKDa5KfDeTc9tj/KGok0zEi6rLr6Fssbp16/utR5S9HUntI6laCEe7ccE2SkXU87ueIY8pDCG/A6Oy6QOiLCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733164261; c=relaxed/simple;
	bh=2iScdVCBMpmjjiCXk0OlK00wqChwDzGVlJmeztoW5S8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CNrLUSJ8oCmqRMzI/7hbo/7JbYk9Xr51eBRDBdstFVTnjGneCuzOVH2C8HN8VMuDwgJPhomZOsn9XQE+telD9pLqY8cFt68G007MhxGFqEa/qGMIP0wb92Av+EOWqREGwcSLy2SSHqo8g8X+CtShuhp0yxbjnmPXn+idfJBINw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r5d351Mj; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r5d351Mj"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3ea411ef5a9so2167923b6e.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 10:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733164258; x=1733769058; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hr3Gd/LiFtAjtQkwDJjm0PXxkVfJjoGp7ojBnwj5Gag=;
        b=r5d351MjyADQLDy6mJVjIAzyE16KLkSTNspu8aY8zDdQfJiRj9WtoTH4/UO2pZoV19
         jOI0NSyknXdjkOf7OGfo3PUyxxU5azRbox1oV7CvgGKWfz6Q9QZfPRX4nItac7MlVh0X
         GraL9cy/ml5pD/rsFenwzy9NaV147ptXmPKO1W/tDYy0OP4HurQOkin4Bx3lqU25NE6Z
         wJp6Ji3lz6EwvKtkCposlH8iB97IHVV6QYIu4zFvthld9TJm/UzKSr9v5dABIfi6XxvG
         yRUSvkoAmOuuyFwBFoo9mrepW6KaCFB5L0fNcdELZ5MjuIDxgpfguK/dcpXBUwjQ5J0U
         E7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733164258; x=1733769058;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hr3Gd/LiFtAjtQkwDJjm0PXxkVfJjoGp7ojBnwj5Gag=;
        b=VYjzbnhcSchntW2wTCnmuAhWXtxYJLWkKgt0gFo4B6RQQmADobYAP0SZmegRcJ7Kyc
         QG8tmgOCQAIgOSnaDWtz5KgGIibomLRDlStJ/ePGUtVAWAAd1bI97JUSm1eJyrgqzKY7
         Z9N4/qg8e0O+8670Z/fEEVO6NrV++jrAyFMi1iZTjCU/pF+HTBIdy+SRCflX7SBhXVHN
         LytdzOgs8k1XZThmK51lnxWrU8qIhmVEJiJMAWzdTS3rBXr2q6gg3fZ87HyIkAH2k4dl
         nd60K924rmhshlbzb5LlaBeTerTU9B3G39ipostRQxSt1JcToIxSlTpxIVE8Jm7XiwBF
         sxYw==
X-Forwarded-Encrypted: i=1; AJvYcCW9wWvvemcDdTiRdUxtzeUmfASKjvjPmD/kWQDmW3XNCwS8JbMqbhuBWlqoShVtYXfuMCfiku8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZLLjtIqXe1cF+YaS0u/8nU8OF53yLCrkboZ99gL4hP6lEHEqt
	9AQVAE+kKNs9XtsFDY6rhivc8qC03LQ29/n9nGmL9BKoN1SxK/eiGawKJDszAi9wYgOAcvxCvTa
	buqbqfoQeqtSU0pSnTSpNWJ7zJrntZp+ljcfAYg==
X-Gm-Gg: ASbGnculNqsaJQtzXyCBsdkCtnwVpsxOxkTpgvofOX6uCjVMTecpxPOdAYPwjiQdoXj
	9/vjyiWWEFepT5nOqiwNVyy5TJW4t7KiF
X-Google-Smtp-Source: AGHT+IHlNZ0c3FgMSDeb4X1ilFXmlXpiLh2UyuryMRixGlP9qIERz81Jb/a0RHj6dZKqNN3qYCgeYR/htw4LOwHnoLA=
X-Received: by 2002:a05:6358:5d84:b0:1c3:75c6:599a with SMTP id
 e5c5f4694b2df-1cab16a573bmr895060655d.21.1733164257961; Mon, 02 Dec 2024
 10:30:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Dec 2024 00:00:46 +0530
Message-ID: <CA+G9fYu95a2Dy-R-duaieHVOM9E+zeKu1EF+YJydnaD7nxnhQg@mail.gmail.com>
Subject: stable-rc: queues: 5.15: arch/arm64/kvm/vgic/vgic-its.c:870:24:
 error: implicit declaration of function 'vgic_its_write_entry_lock' [-Werror=implicit-function-declaration]
To: linux-stable <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, kvmarm@lists.linux.dev
Cc: Kunkun Jiang <jiangkunkun@huawei.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

The arm64 queues build gcc-12 defconfig-lkftconfig failed on the
Linux stable-rc queue 5.15 for the arm64 architectures.

arm64
* arm64, build
 - build/gcc-12-defconfig-lkftconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build errors:
------
arch/arm64/kvm/vgic/vgic-its.c:870:24: error: implicit declaration of
function 'vgic_its_write_entry_lock'
[-Werror=implicit-function-declaration]
  870 |                 return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

Links:
---
- https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/log
- https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/history/
- https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/details/

Steps to reproduce:
------------
- tuxmake \
        --runtime podman \
        --target-arch arm64 \
        --toolchain gcc-12 \
        --kconfig
https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/config

metadata:
----
  git describe: v5.15.173-312-gc83ccef4e8ee
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: c83ccef4e8ee73e988561f85f18d2d73c7626ad0
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/
  toolchain: gcc-12
  config: gcc-12-defconfig-lkftconfig
  arch: arm64

--
Linaro LKFT
https://lkft.linaro.org
