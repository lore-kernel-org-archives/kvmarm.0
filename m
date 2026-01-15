Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A5D3A0B16
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499081; cv=none; b=YUOaQQ7RdatTAHjwgJklpksVrwJpmTldPGRzf6eTVKb4OCHDjCG0HuXNpF9zfDoEJxM8Syk3510PNZ7ehg+et6JLH3DxESg9ebjIL2f+cbQNSfKcwJZkPhKA2WDWJtVPuNF94d7vZYW9NlQIyiDd8uuFApnr50MF2ApVKzyjh3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499081; c=relaxed/simple;
	bh=P976BOHLnV6sVYTAnXc5kPCIkTAoCioEWsFNvBAlj10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NRTMkXHCWwJeFuZIBvqzmJfq6XyZMxqHXq5dU4P9dn/MX9Aa77rw/4Q3sn2CdJ2j1ZeTP3mjAAmkKY4mUp5veEiMLxQo6lBv8WUNrOs+8OaZhf4yTFyE3/QzG0tDRR1er/Ca/zz/g9pJ3uVi6qXSg9xu57MJ1C3m/z1Tqw019oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NATUilqy; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NATUilqy"
Date: Thu, 15 Jan 2026 11:44:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768499077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hePkjZ91yVumu/kAJG4D+Rdy/dn636U2VtRIR34dJkU=;
	b=NATUilqyzPOnnJkZfVvVbhGLAVXzARrX1e4ywPlO7n6m4OvbVDgjYZpC4m2TtqmHlnCIHQ
	/UVJD6lrk5qbRrJodjkadw0kbh0Zuelvnp0QuP+gYgabgfTpNeudiZd2HMwYD9gptEJJXY
	j5rDi+vFc5o4DZtO9/QBdYVcJSI4jtU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v5 11/11] arm64: add EL2 environment
 variable
Message-ID: <2yzhh4aylpjmff4wlehzqsbmexdmphzvh3gdm34ygnoxrxljzw@emvamgbokscf>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <20260114115703.926685-12-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114115703.926685-12-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 14, 2026 at 11:57:03AM +0000, Joey Gouly wrote:
> This variable when set to y/Y/1 will cause QEMU/kvmtool to start at EL2.
> 
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/run | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arm/run b/arm/run
> index 858333fc..266ed1cf 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -59,6 +59,10 @@ function arch_run_qemu()
>  		M+=",highmem=off"
>  	fi
>  
> +	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
                    ^ == instead of = here. Same comment below.

> +		M+=",virtualization=on"
> +	fi
> +
>  	if ! $qemu $M -device '?' | grep -q virtconsole; then
>  		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
>  		exit 2
> @@ -116,6 +120,9 @@ function arch_run_kvmtool()
>  	fi
>  
>  	command="$(timeout_cmd) $kvmtool run"
> +	if [ "$EL2" == "1" ] || [ "$EL2" = "Y" ] || [ "$EL2" = "y" ]; then
> +		command+=" --nested"
> +	fi

Should use some blank lines here.

>  	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
>  		run_test_status $command --kernel "$@" --aarch32
>  	else
> -- 
> 2.25.1
>

I've made the above changes and also factored the checks out into a common
function

diff --git a/arm/run b/arm/run
index 858333fce465..2d5ee672ec13 100755
--- a/arm/run
+++ b/arm/run
@@ -59,6 +59,10 @@ function arch_run_qemu()
 		M+=",highmem=off"
 	fi
 
+	if is_enabled "$EL2"; then
+		M+=",virtualization=on"
+	fi
+
 	if ! $qemu $M -device '?' | grep -q virtconsole; then
 		echo "$qemu doesn't support virtio-console for chr-testdev. Exiting."
 		exit 2
@@ -116,6 +120,11 @@ function arch_run_kvmtool()
 	fi
 
 	command="$(timeout_cmd) $kvmtool run"
+
+	if is_enabled "$EL2"; then
+		command+=" --nested"
+	fi
+
 	if [ "$HOST" = "aarch64" ] && [ "$ARCH" = "arm" ]; then
 		run_test_status $command --kernel "$@" --aarch32
 	else
diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
index 16417a1eba38..01cc1ff29728 100644
--- a/scripts/arch-run.bash
+++ b/scripts/arch-run.bash
@@ -596,3 +596,8 @@ set_qemu_accelerator ()
 
 	return 0
 }
+
+is_enabled ()
+{
+	[[ "$1" == 1 ]] || [[ "$1" == Y ]] || [[ "$1" == y ]]
+}
-- 
2.43.0

Thanks,
drew
