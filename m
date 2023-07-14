Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54C6D1373D
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 13:16:16 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D3BA1570;
	Fri, 14 Jul 2023 06:16:58 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 757243F67D;
	Fri, 14 Jul 2023 06:16:15 -0700 (PDT)
Date: Fri, 14 Jul 2023 14:16:04 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvmarm@lists.linux.dev, Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: MAINTAINERS: Add reviewers
Message-ID: <ZLFKlGnN4rGpKjKn@monolith.localdoman>
References: <20230714125257.333242-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230714125257.333242-2-andrew.jones@linux.dev>

Hi Drew,

On Fri, Jul 14, 2023 at 02:52:58PM +0200, Andrew Jones wrote:
> I've recruited some review help!

Happy to help:

Acked-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe2c8418faf2..958735fbfd79 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -76,6 +76,8 @@ Architecture Specific Code:
>  
>  ARM
>  M: Andrew Jones <andrew.jones@linux.dev>
> +R: Alexandru Elisei <alexandru.elisei@arm.com>
> +R: Eric Auger <eric.auger@redhat.com>
>  S: Supported
>  L: kvmarm@lists.linux.dev
>  F: arm/
> -- 
> 2.41.0
> 
