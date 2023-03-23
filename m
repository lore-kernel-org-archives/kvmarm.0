Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2D93C04
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 18:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023FCC433EF;
	Thu, 23 Mar 2023 18:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679597818;
	bh=TTOT8BXKpDeG0idarmpx7k8xv/rMwqoTTTQf32UWpSg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RXU0q9pTHsscMAVR9AF72Gv5Shw4fPRcGeNliGWbcTKn8b83OSwOfKJcRk132OWfO
	 l6CG1bRSU5nSLhnxcjxxbGX+n03XnAxi3qNv11BlZpWWw2UsrltFW7ZjDQ2UAqgkRz
	 r79cz9aQ3GBWuszc2XpJSW1kySDniQjbfdUfYF91YAVDXKB0urOgBqfzBjhx9B71yr
	 VWRQCoxZpbkDI2T2Mmh1GvlmGqzIyIn5LplMlvsBq4T5vn+cSbn0P2tiYsKDMWzksx
	 mqPL3u+kuNlP4BSJadVZbWZPhKsnYH/Ir07HVl6x7blB9BHUmmCn5dyRiWUIdmsf1V
	 48LnO2WPiMChw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pfQ7L-002cXH-GX;
	Thu, 23 Mar 2023 18:56:55 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 23 Mar 2023 18:56:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 0/3] KVM: selftests: Fixes for broken tests
In-Reply-To: <ZByOn79zokUpLGSs@linux.dev>
References: <20230308110948.1820163-1-ryan.roberts@arm.com>
 <4eca298b-411f-e6db-04d2-e8963a0e5d98@arm.com> <ZByOn79zokUpLGSs@linux.dev>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <2d3bc930bd3fdc20a7257b6f343313ed@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, ryan.roberts@arm.com, pbonzini@redhat.com, shuah@kernel.org, linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-03-23 17:38, Oliver Upton wrote:
> Hey Ryan,
> 
> On Thu, Mar 23, 2023 at 12:56:18PM +0000, Ryan Roberts wrote:
>> Hi Oliver,
>> 
>> Just a polite nudge on this: I was originally hoping to get these into 
>> 6.3 since
>> I thought they were fairly uncontroversial and clearly fixing bugs. 
>> What are my
>> chances?
> 
> Yes, your changes are indeed uncontroversial :) At least for me, fixes 
> to
> selftests take a strictly lower priority than fixes to the kernel 
> outside of
> a merge window. AFAICT, only LPA systems are affected by the changes 
> here and
> I'm not aware of any of those out in the wild.

Agreed. My usual take on fixing tests is that unless the test has been
broken in the current cycle, we can safely delay merging the fix until
the following cycle.

And yes, LPA-capable HW is essentially vapourware at this stage.

> 
> So, unless there is a burning issue, I'd like to defer these patches to 
> the
> 6.4 merge window. Nonetheless, it all looks good to me:
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Thanks for that. I'll start queuing 6.4 material once I'm back to my
usual time zone, beginning of next week.

Cheers,

         M.
-- 
Jazz is not dead. It just smells funny...
