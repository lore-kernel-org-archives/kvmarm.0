Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261A335A93D
	for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 14:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991540; cv=none; b=c1HfisVxk+XnpyTkQwopV/jMERZGBgCzL6/3dp51w1IwFSnlFDaWVu91FDHzfxpJgQAzT7wMb9hOF/nOl6bVmhVScgeulhkvbJMEZDMGUHM8ME07JD7IQcOHJ6xF7Oi2gJHqzjL+ukYd7g6oo0ieU2MrUKmgMGvWinod9Jt7BJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991540; c=relaxed/simple;
	bh=9igXrnwBkc2YWACJRUYykc+aAi4M6tZrhZFSiR3nthI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbuKeVfdF8JOwgeOWHAOLiKtVMnaEZBFyQ7tVgIf0CUmVwfHZUyYvnKt6M5IO1gTtS5Qf1fAJhDJWfKQ2igEJIamaqe3i9qYe/rmpLeFZRJ+uXv0bZ26BDB8rT18BIZu65wgUH0Wrx6kO+q/OxMJVwngdEcoFKb7mLlvcTf1xdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ReqWpVdr; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ReqWpVdr"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59dd54b1073so1126945e87.0
        for <kvmarm@lists.linux.dev>; Fri, 13 Feb 2026 06:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770991537; x=1771596337; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DpIFlmHj6Ju02lNAnX36Twujx6eGFiHnJwHWalJ8FA8=;
        b=ReqWpVdr8KZjVYlojp8YKtL2bnaIOJnclcw5zz9VtQhyckL+pNjRss9HRUxuNcglYP
         MHBNgN2kPPTVe+Sn8zXKaESZeWKnV9LK5GGZAJ9iyIDcZ3otT6l8XdoLKjjQT6Sik/iJ
         A0Gy+BXaVLkcctEWdizv/BSJKoyLfTxiwhcX2mawtsg6+GZ2C0XBuYP7iMozY1HvPSSt
         EldeEskY/93Z9UST9f8+ZayD//+aA7JlHHF3INqqm+R5h5ICW2uVSn6iuZKJbQNk2y01
         oxLnk8uK+oCu/RvJyuwVPqwDGAP6LeX0YcFAKvSNxXuEr/eVAOcJckPzsVu5iutH4v41
         TM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770991537; x=1771596337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DpIFlmHj6Ju02lNAnX36Twujx6eGFiHnJwHWalJ8FA8=;
        b=auOCTj0B28b2Jxn92umtoVOShCFMo7r+DFI7XCWXJCth9gluMjHYuMxyc+Gfzy0KS9
         hndX4T0YMwNlb6fIGfPanQQudSG+v+Wd2OM3UTAG4P7Hnwdo+KuaOJPvUmRreLQc5hkN
         HiN0NCoQ342V61oHbnxSjOfIKCTaMzidrAC+dT0laTDU1PMNkENIQb2qFt8esAIWzni4
         LDomKk5sSg0IaghqgET+B7KN+Taa1qX6y4/EUm5N+zjf8wQFU7FlG1MBmaMWJyiJbFm7
         5gGFjEwO628epjHz2l299TiKbIu+1p7R7CyjKrFDlvPl7lKWEro8v9iwmqT4NrJ55s5g
         rrQg==
X-Forwarded-Encrypted: i=1; AJvYcCW7mKb24PwWyVUOuuwLxPaFjqGVMEDYfIuqBC9PR8lK0PZYZqZPjSOPiZz8aFiqyDZdiJQ09EU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAnFZBP5clqa1BOdrVDrvmS9iNxyS1NzYMGmzDgNUsZBwc2Z++
	RSW6olJQwU5hWF8ieVmt1ZgBGGInxnlfBKgurwuXwJLzWvA2t7FaIPH/j4I06Vt0Lg==
X-Gm-Gg: AZuq6aIFSSo07zVW+nCPyyx5lPfFJe53IydTbWZGMSS6CnvIbwasrJ1DEMSJNvWnf6q
	fqDUB6C1ncHWWcU/ocgB2dSBCYEurQWV3eXUOwEZscZujoB0/CNgqLlS4OxcTagMjeiVmE98qZ9
	KTMUaXj/Fsqt7YVZZWoF9p5ru4K/bY1sd99aMnjYsyeAJaqyCgSP+2a6r95EkYZ4bRHn9CHpOQn
	ZWMfUHHZyBQ10fzMUdBe3k0MM6H8VhiHWVlrsyfStJsavUxy68G0Fc1ZKgRdHKU5/BvXNQWxaBZ
	jCqSZ2ZnKX2lKGDcD+d2a7nBigEJg0KwqrDqeA2VeMQqk6KX6vkZtrOG/nfauDt9/ZW8V2OkqCD
	J4You2oU6VfVyeyTAJAhtyE9CtgO5+wQ6ujdUJX8XYNerImESBuIKo0iORyK38z/Ec+Ma3CeEZn
	Emz4odJqoc5j4QEkQIo1nx4OE4SJN2CTmzg0HFyMd0UQf0WhO0LEKz7trY0Q==
X-Received: by 2002:a05:6512:b27:b0:59e:133b:f768 with SMTP id 2adb3069b0e04-59f69c31823mr772689e87.22.1770991536799;
        Fri, 13 Feb 2026 06:05:36 -0800 (PST)
Received: from google.com (133.23.88.34.bc.googleusercontent.com. [34.88.23.133])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f56312csm1634563e87.6.2026.02.13.06.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 06:05:36 -0800 (PST)
Date: Fri, 13 Feb 2026 14:05:31 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, hyesoo.yu@samsung.com
Subject: Re: Broken udelay() on KVM host with a vcpu loaded
Message-ID: <2iagurz5lvvdr7vavcz6foaxrgeyzcv44rkvvbge6n4fm6gcqh@ixeuwzvskvq4>
References: <ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od>
 <86qzqsbw1m.wl-maz@kernel.org>
 <aYtP_rgolLfm_UDD@willie-the-truck>
 <motrqsddhooajk66sq75dt74huvxmwtreoznwc6yjqirit36bl@2mlt2546mjnp>
 <86o6lwbchv.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o6lwbchv.wl-maz@kernel.org>

On Tuesday 10 Feb 2026 at 19:54:36 (+0000), Marc Zyngier wrote:
> On Tue, 10 Feb 2026 15:58:14 +0000,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > Ouch, it does seem that the SET_ONE_REG stuff allows to mess with that
> > value _out of vcpu context_, so yeah userspace could change the value
> > while a vcpu thread is preempted in the middle of a udelay loop ...
> 
> I don't think so. You can only do that on the vcpu fd, and if the vcpu
> is loaded, it means that you are already holding the vcpu mutex. And
> if you do that from the vcpu thread, then you already have done a
> vcpu_put().

Aha I had missed the locking here -- reasoning about SET_ONE_REG being
issued on a running vCPU was 'interesting' :-).

    Reviewed-by: Quentin Perret <qperret@google.com>

And also, I'm only relaying a report that we got from a partner, but we
might want to credit the original reporter:

    Reported-by: Hyesoo Yu <hyesoo.yu@samsung.com>

Thanks for the patch!
Quentin
