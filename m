Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB502C6A0
	for <kvmarm@lists.linux.dev>; Mon, 15 Jan 2024 12:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gdhd4I4d"
Date: Mon, 15 Jan 2024 13:26:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705321577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WDfsB57fdrpRjyDNya3EtxYb0I/brPhBeMXt0+IM3MI=;
	b=gdhd4I4dlLj4Sg+b1pAPM+1VwoeFQ5rG7HCPDRZbxS1Mn+679/EABCU1OW42kCReD4Kzle
	iLwDjIdShXAV3LBr+4TKwyB4Q3uBgu3bHUNpVHqtbLcp0k0udHOOrALmqURmaj5gnS4NI7
	Qcec1Pj10VtfidRhCyHFYJfKKa0DH+E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Nico Boehr <nrb@linux.ibm.com>, 
	Thomas Huth <thuth@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Sean Christopherson <seanjc@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/3] runtime: Fix the missing last_line
Message-ID: <20240115-8d47914acc8339f2fcc20807@orel>
References: <20231130032940.2729006-1-shahuang@redhat.com>
 <20231130032940.2729006-2-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130032940.2729006-2-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 29, 2023 at 10:29:38PM -0500, Shaoqin Huang wrote:
> The last_line is deleted by the 2607d2d6 ("arm64: Add an efi/run script").
> This lead to when SKIP test, the reason is missing. Fix the problem by
> adding last_line back.
> 
> Fixes: 2607d2d6 ("arm64: Add an efi/run script")
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
