Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA731A3163
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 19:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738954982; cv=none; b=FhcbIK2Kz7kmAYC7pZ9tw7QjIAdgqHx5ZyXyhAHyEQOJkhO/C1RKgGfqJnVc9Am7N0YYQBsrlth37RImnF/yY4SavWD/CFgrp64bOEbuohsLaGZmv5MfZYiRcNXdZOhgcRKyop+k0cMRoOL7TDzMgGdDHGjTPol4ULLIzzlLA3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738954982; c=relaxed/simple;
	bh=B0DC6l/XyLB2yPBibKSZLZTItmwhOJ+NhorWu6VR1OU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P6Drgj2FhNBzA9vxG1cmvSjx8qk7LnrRm8r60+/Urs8+VVW9HL9F0KQC/T/8uLtr+6O1gpMt9vscgWUfVqV81IibbTBFiHWPjczzf9XcAy3lHpY9bC4ozPlbAb8yK+moka8cVa6rzKrShs/jwJoWNR04XxRr76L+L89jldgNuh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WBKCOrrL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WBKCOrrL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21670dce0a7so58212135ad.1
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 11:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738954980; x=1739559780; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x5iLhqQVo5p3cfm1ZHXkEjzjBbO03jMKvKOw7vCeE+w=;
        b=WBKCOrrLiKCme+pUnZtv18RQB2tz93viV+MaAgAnfDxLXfI0D90sXFpo8367t4zhQt
         pJ1dJMN1/sEOfPVcSADNkXMJgq36mEw8ifFA2/cDEwr0vL7HZZF22yaq2t1ScHh2bhtd
         u6h1ZWp4AktTKRpAjYUQ6hPSHb5HawWpd69nxEMANHmxpYuILDAcjA9Rbh/chMvDypoB
         aBhqwrbhYWwtVkhxA++tzhVq6Jw2nvn01efHodqACmOgNYR49XUYrIzcfmHNzQMqZKep
         k/MXL5knr8BhpHwY8xFWNuIOV69/vimzM6i3R7qDZTkzDEMYDFa8WtCl5UOpI3JiZbi8
         Cj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738954980; x=1739559780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x5iLhqQVo5p3cfm1ZHXkEjzjBbO03jMKvKOw7vCeE+w=;
        b=wXDqmntW7GqbekV2o2jo+pfXSh3CnLeePRFXpg2RfCwR1l31JCl7Mf4g0QjqjdWg99
         l1VEz+Eic0wVaEiBHcmN5LX4+tJV7rqn20aZ3r37K6mxzqSut68y2zeIcUsbHP0h+yBq
         zNnAyhES12KdoMLlTEipOKzSlH1ESlVXhNGoTVRoccsJx5P+82soGU+M2Kwrx1ytnHCO
         /ELapZGmHN7iV5AayDBUi7theJpOrxeoBGe9cKKukk9RFs95tK5ZD17l0m6Jc2J7d9RO
         j9EbcgeqPftwTf5H7ZMgjVdpXcwPl5z5ncqTyjpuD3zagSHc5lCP5LGIKi6BJ9e5jC2u
         2Bcg==
X-Forwarded-Encrypted: i=1; AJvYcCXmP/NK/nYSDPwCqkmF+IKe0HsJC/r6N8wyrO8pDu3Vg+kbnvfkm8uYIGi+J2iE56R+vF4wEbI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4as9xkvoJ3W+2CQAgjjaeEPDSXc9c0OZ/rDWyUTwIl+qxvfm5
	Esi23yzxnd7WVDhX+w5OjcB/eleVq8yVFwrkhPgAtQ29r+eIl3UQu47se7Mxgqs=
X-Gm-Gg: ASbGncvcWs2NS4J6dAo+LekcgwfjccPAVUWyqUFEF0SSRCjPsWZq38/MpGtQ7F+Ap2C
	CI7sAKZvNdKZrsBnjr41j4+BhcxpL5QnGkQbhXGDOBL1+rNUt9tjSsDXb2GOZ29dimVIjD9+v9y
	u90OZmUvcQXn0OohCquKXzaPTyyP36Ftvs4Ms1SvqTnIr6PwuZzVxApCUBL9tmNPDphSG8Q/kRE
	yiDO3fr94AfaJjjEy7DEdeecDvaoJnpzzFaIC8faAZF1xHOzkd2KYil60jsbQq/TGf7vZWMGdi1
	0mW+W4gKe/05NM8MwEibnLqeg8c12TeUc1EonhGd3WZP10rq+WlVpzU=
X-Google-Smtp-Source: AGHT+IF2LLaNMwiUuHQAdJOEiXolxAl+x/GhHZKndi/U9zcgMdqVqF1FKAZ6FFPxdWK01sK6FPeYuQ==
X-Received: by 2002:a17:903:1c4:b0:215:72aa:693f with SMTP id d9443c01a7336-21f4e6ce75emr60838215ad.9.1738954980335;
        Fri, 07 Feb 2025 11:03:00 -0800 (PST)
Received: from [192.168.0.4] (71-212-39-66.tukw.qwest.net. [71.212.39.66])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21f3687c68asm34363405ad.172.2025.02.07.11.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 11:02:59 -0800 (PST)
Message-ID: <f5878231-79b8-4e29-bfb0-f9a57ac3f6a4@linaro.org>
Date: Fri, 7 Feb 2025 11:02:58 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/15] arm/cpu: Add generated files
To: Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-16-cohuck@redhat.com>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250207110248.1580465-16-cohuck@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 03:02, Cornelia Huck wrote:
> And switch to using the generated definitions.
> 
> Generated against Linux 6.14-rc1.
> 
> Signed-off-by: Cornelia Huck<cohuck@redhat.com>
> ---
>   target/arm/cpu-sysreg-properties.c | 716 ++++++++++++++++++++++++++++-
>   target/arm/cpu-sysregs.h           | 116 +----
>   target/arm/cpu-sysregs.h.inc       | 164 +++++++
>   3 files changed, 860 insertions(+), 136 deletions(-)
>   create mode 100644 target/arm/cpu-sysregs.h.inc

Why are we committing generated files and not generating them at build-time?


r~
