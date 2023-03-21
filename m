Received: from out-53.mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C9FD30A
	for <kvmarm@lists.linux.dev>; Tue, 21 Mar 2023 18:21:45 +0000 (UTC)
Date: Tue, 21 Mar 2023 19:21:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679422904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0XP2feTT2Z2INPHdm7OkUTkCkmq3/0dKtwzIAK4qP4M=;
	b=mu26yxoUUDKKXI+owB4m1511CeXntWGz2MRL9iEnhX14pxDt04Z298MGOpeoH1QTTtN1V4
	7kkyzKSL15Xa+wt7bvLE1YJ1GccHWNE5EZbZMAZZwy9uG3FGgZw5IVvVizwCibo7qiOK8v
	foL2ZqVZNsFyz5OCs2WvNCo4k4/4vUk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [PATCH v4 28/30] arm64: Add support for efi in Makefile
Message-ID: <20230321182143.q4pctesnrunnvak3@orel>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-29-nikos.nikoleris@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213101759.2577077-29-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 13, 2023 at 10:17:57AM +0000, Nikos Nikoleris wrote:
...
> --- a/configure
> +++ b/configure
> @@ -208,14 +208,19 @@ else
>      fi
>  fi
>  
> -if [ "$efi" ] && [ "$arch" != "x86_64" ]; then
> +if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
>      echo "--[enable|disable]-efi is not supported for $arch"
>      usage
>  fi

Need to also update the usage text with

-           --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
+           --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)

Thanks,
drew
