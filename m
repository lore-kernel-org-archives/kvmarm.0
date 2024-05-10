Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2679217108A
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715353598; cv=none; b=Ky3I6ZH/gQvCpFIdOa2ZWN/g+tH1EQYH1/lDEjWrEc1Nu4cCwq+glLKTLQULzZqrwqhEu3/0tMGRN+8i0fJEYXo2OOBfbgncOtteQ4SL+ux1fIA5RtEporFoFZ4HblqO9UmsX1U6ENPVFakwjCDD+dpI5yZKjLO66l9sebS0nlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715353598; c=relaxed/simple;
	bh=KbKZCqi13hek9lMrMs/b19wJyB74O4quMNE0pHcL4Ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtEDYgmDGSn7FJGG5OveGZTdssmKt2e2j/tzr0V9dd4ZHxe2Cz98363vbvkcUcTzloMvwmOpwO+/82lkuhRzlWf+iyOalJCXEKSyR3FtQnKcDifsvHD4FFqQxD0bVWeCTA+JPO12rhW0/bceFi8lATulbAG6Ld9TBHu8oAzi5n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=o9k0N9xR; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="o9k0N9xR"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-34f7d8bfaa0so1573592f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 08:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1715353595; x=1715958395; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hpXHNbhUwqjNWAwvcdLiJ0T9kect4OfhD8OioMXo/R8=;
        b=o9k0N9xRB/9W2HvJFSL2sjBua7zP8OWw314xKSh8BIYifGdRnwtsEmKx5lBniuF5sW
         Gmoj6aVomkXbaXYYieMwWvJCTtNutyXPN50fqZV6lyAeOXWSeAaXnyKM1vHHsr5deZjw
         MxV3NKHtUL2iWAABsRhrbjCNXl+J/ksvBPZOiwuTJYm+6YbxjygX57rYQX8O7Rd8wT80
         wF4XBNcLXXUUCJz35SOz/fUkG0OZLDCjllyZff7dIxyjszymSaypXVjR7ywrl/mwC2tR
         rXcvrThWA32GdyKGCYQxawdZbztAP8dOjs+FUSlopIgwo3hlBpW4arciSa2Dmud6rHSu
         9JGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715353595; x=1715958395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hpXHNbhUwqjNWAwvcdLiJ0T9kect4OfhD8OioMXo/R8=;
        b=E+pGyVkPNTG3JEe7wHBsTRRXROi4AcgNKkA+ZnhLGXq5OJWcT69zlllpuqdx15g8iL
         qd0XEq0oteNLoB0gHMTbqTcRiiVwJp8vE9dfPoEAWoQ1yiB51+dvUggxz/hbcHXxLwHg
         nBxoTe+AP1nRGwB44Zk55fT0/92n8j/DAqrr1BeRFqMsSJB6B641Jez9XpRh0a3CKl40
         BRmswTeeYxBYZkYh6jymQzurq5KJ8+z0Z3+oxDqoTyIT/lbBd2DmEHv4AOtpUgrM/xbF
         mluS7S8ul7NECprKHWNpqR8BM6zh1WoKYVSD4bfiCiEtPz9109r+DEseZpznJlrnqVVL
         UJFQ==
X-Gm-Message-State: AOJu0YxcGTqclk9CR07xitU2zypA73N4ncL37ucSMiXWVpvlYltwYpW7
	qUExk/ecA3xQu8SfwiIQK3IPReNtwc1EUhU5JUKYFl83SDnJjpxi2633MPmoVok=
X-Google-Smtp-Source: AGHT+IH1eYGGbrBrQrHgx0UYUQLI4uRRwuHgfVh7sx1vxOMo7IRCFX6Ti8tQTtNkjEWxxjcShgnO+g==
X-Received: by 2002:a5d:6a8d:0:b0:34d:a86f:ed09 with SMTP id ffacd0b85a97d-3504a73dd57mr1973451f8f.41.1715353595388;
        Fri, 10 May 2024 08:06:35 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3502b79be12sm4812421f8f.20.2024.05.10.08.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 08:06:34 -0700 (PDT)
Date: Fri, 10 May 2024 17:06:33 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, nikos.nikoleris@arm.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] arm64: Prepare for LPA2
Message-ID: <20240510-624911617f8aa203feb7d79a@orel>
References: <20240402132739.201939-5-andrew.jones@linux.dev>
 <20240402132739.201939-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402132739.201939-6-andrew.jones@linux.dev>

On Tue, Apr 02, 2024 at 03:27:41PM GMT, Andrew Jones wrote:
> When checking for supported granules also check for the values
> which indicate support when LPA2 is implemented.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  lib/arm64/asm/processor.h | 49 +++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 22 deletions(-)

Queued

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue?ref_type=heads
