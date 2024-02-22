Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B11468F8
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708611710; cv=none; b=GbCucVHqLl0Vr+XCGE0Ud8oqPuQNxYlW3/oL5E3N/lxMcVo7FfEchQlQ3Wy/YVrxcFnXoxvy/YCUgzgS1C15OO/xmfj1I1Q7o4C4lBBgL7owZapSnVJKmyPuCaakvObRm4tCmr2k1s8uVTm4vxpcRY72fck+u4WS1hnbvm9ktWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708611710; c=relaxed/simple;
	bh=QGH/oY1Gj/jzPFbd2HxBuEtJvQGhZiWeNYM26WmtjkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+6oZ9KSJVfMAcKd8vD52TofV6ACrIbg2iL6eB2+2cY9DACOeYhh7Mcr25/xmY7DFEEwWPvsYJxEaIJSalWy+2ZI5ScLSsdZpehlmLGM8LWj3xEBN3+M6nhl4DL7rGzt3SUSHfUmaPMCdNZsARYof2EV+oDQ0ToZcERZOw9sQFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VmqkGlwZ; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VmqkGlwZ"
Date: Thu, 22 Feb 2024 15:21:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708611707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bpvtni+S4EGS+6b6TR7x7lkB+yShI08CHZL3oPUHTxY=;
	b=VmqkGlwZVE7/AIGqgISn51wgkjmqtR+Zo9PjZO48nKnunaAErHMsxgmOJ0YFtM6FNYws6y
	7BFVAH2/eH+16n0cDyoRqF9+UDxBioG46F9EKmCmPaQXHmRsRwUyOHbbuk+tpLeOOiHSOy
	k+sKpjdmVixbnlGZP8ANJeXYbwcrZAw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Nico Boehr <nrb@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Colton Lewis <coltonlewis@google.com>, Nina Schoetterl-Glausch <nsg@linux.ibm.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/3] runtime: Fix the missing last_line
Message-ID: <20240222-3692763d5a20ac15259c4668@orel>
References: <20240116065847.71623-1-shahuang@redhat.com>
 <20240116065847.71623-2-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240116065847.71623-2-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 16, 2024 at 01:58:44AM -0500, Shaoqin Huang wrote:
> The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
> This lead to when SKIP test, the reason is missing. Fix the problem by
> adding last_line back.
> 
> Fixes: 2607d2d6 ("arm64: Add an efi/run script")
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index fc156f2f..c73fb024 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -149,7 +149,7 @@ function run()
>          fi
>  
>          if [ ${skip} == true ]; then
> -            print_result "SKIP" $testname "" "$last_line"
> +            print_result "SKIP" $testname "" "$(tail -1 <<<"$log")"
>              return 77
>          fi
>      }
> -- 
> 2.40.1
>

Pushing this patch now, but holding off on patch 2 of this series for now
and patch 3 will go through the arm branch with some other arm efi
changes.

Thanks,
drew
