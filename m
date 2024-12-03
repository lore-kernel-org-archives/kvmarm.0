Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9186F1DE3AC;
	Tue,  3 Dec 2024 08:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733215999; cv=none; b=o6GhPV2WbqpnnJutR16r/v7AFotuB3QinM45Q4+WCzUkrLxQGoiutIJDm+DfSGDw9ctIzO+FAfsoH1OqQTCumoI/myeHwdlb+31TNfpxH2xajii7Gt/3abAEQpZ5WZyyEWTpk17i/3c2w5t1RXle6TR7wIGHXvxwNI2WMokl30w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733215999; c=relaxed/simple;
	bh=jscd2klIUmk4KilOyH6e+vqW0kYygvXyaLSnJM/vrLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jquPOLd+xfytxkZCsTnWEYel8eBq1rdUFxfBzmVIpn1guVsz+4xCsnNBJ4F/rX/I0CZRNuY2vHs9kq9l5xmjOo2pWN3Y/esI5M+yKgtoBeBIz7cJG666v0/AfbzuXlS1rW1Kq+0/L95bMz9WKSv4DqakCDRU8H87/eg4j2gn/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opDZ+g2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opDZ+g2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C041BC4CECF;
	Tue,  3 Dec 2024 08:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733215998;
	bh=jscd2klIUmk4KilOyH6e+vqW0kYygvXyaLSnJM/vrLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=opDZ+g2d7ZYTV0jLQr7EAyvN29lp52VLNNQFUWWxmS0S5KDJY0bXPyr60QWNPGlS7
	 soYbJeKAXNZdk9cdZLWCkbN5c2RqAuW2Y9ecddAS2z8hhnuIav5/FUH9/Lm/bVvfEe
	 12lEIfTm53N/8HTJbXH9TcNdBsO40n5P3dqt8lpA=
Date: Tue, 3 Dec 2024 09:53:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: linux-stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
	kvmarm@lists.linux.dev, Kunkun Jiang <jiangkunkun@huawei.com>,
	Anders Roxell <anders.roxell@linaro.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: stable-rc: queues: 5.15: arch/arm64/kvm/vgic/vgic-its.c:870:24:
 error: implicit declaration of function 'vgic_its_write_entry_lock'
 [-Werror=implicit-function-declaration]
Message-ID: <2024120306-sniff-labored-f6fa@gregkh>
References: <CA+G9fYu95a2Dy-R-duaieHVOM9E+zeKu1EF+YJydnaD7nxnhQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu95a2Dy-R-duaieHVOM9E+zeKu1EF+YJydnaD7nxnhQg@mail.gmail.com>

On Tue, Dec 03, 2024 at 12:00:46AM +0530, Naresh Kamboju wrote:
> The arm64 queues build gcc-12 defconfig-lkftconfig failed on the
> Linux stable-rc queue 5.15 for the arm64 architectures.
> 
> arm64
> * arm64, build
>  - build/gcc-12-defconfig-lkftconfig
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build errors:
> ------
> arch/arm64/kvm/vgic/vgic-its.c:870:24: error: implicit declaration of
> function 'vgic_its_write_entry_lock'
> [-Werror=implicit-function-declaration]
>   870 |                 return vgic_its_write_entry_lock(its, gpa, 0, ite_esz);
>       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> Links:
> ---
> - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/log
> - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/history/
> - https://qa-reports.linaro.org/lkft/linux-stable-rc-queues-queue_5.15/build/v5.15.173-312-gc83ccef4e8ee/testrun/26166362/suite/build/test/gcc-12-defconfig-lkftconfig/details/
> 
> Steps to reproduce:
> ------------
> - tuxmake \
>         --runtime podman \
>         --target-arch arm64 \
>         --toolchain gcc-12 \
>         --kconfig
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/config
> 
> metadata:
> ----
>   git describe: v5.15.173-312-gc83ccef4e8ee
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git sha: c83ccef4e8ee73e988561f85f18d2d73c7626ad0
>   kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/config
>   build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2pfZrGeL0phpW3aHlpr5cjEzz3r/
>   toolchain: gcc-12
>   config: gcc-12-defconfig-lkftconfig
>   arch: arm64
> 
> --

Conflicting commit now dropped, thanks.

greg k-h
