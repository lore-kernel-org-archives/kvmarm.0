Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141F21E5B61
	for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 15:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742484589; cv=none; b=l6LZDUUxw7qAgUmV3sKMWwWnXMsu3KTpdx7mdUfRlYiv2I/k/6U+gPppHg1B9UwIPqFhAukF3l3mNYRfOeGaOWs/Q6vTPaFYIsTwHAYr2MYww+WCprB29cP9eP7TaJZr1h12xUgRolnEQ2mkTAkJ0kAtZ7QpGDrxySXRSQfaInw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742484589; c=relaxed/simple;
	bh=UDAge26zHcWAV5000rB0kL1eRO1Rn0hZ3PXlztHNfxc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tLjxWJQdwlekfQPCYsQQhkktaW297LqZAkOpyr+/+pBJM1AYcO1aLUg3kotPNLEz+bAW1FoavfJG0Mj73S6DlDJdfFFBQ0u79GJ88UnaxT7uKtOnOdpaZtmxQUWHkQ1R+wVXljylk+oYjplUE/yV3r0vH2AjWcicMpW86Xc7eLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=We9wWrcJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="We9wWrcJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742484586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FHzTTbYYErG3BHAoth3Rm1XEBwqah4VOUhcwHJtuowg=;
	b=We9wWrcJuQzRz2YNaGGyyiQvZ9/jV1vCPsLqbwig021ZtCGv56In14uRIMq2Z2K2Kwtc8N
	LJZSfCS8JGHGpHtJbyzsoNRUZ3kUmsa8M77dxtK3XWPqf9O+8dhnr7uspz3tGFfanCkz5B
	RpqHFqXVodElMJaJaYsWWGktib2vP2w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-WjJw5nJFO0GTLcJgS89V8A-1; Thu, 20 Mar 2025 11:29:45 -0400
X-MC-Unique: WjJw5nJFO0GTLcJgS89V8A-1
X-Mimecast-MFC-AGG-ID: WjJw5nJFO0GTLcJgS89V8A_1742484584
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39130f02631so414643f8f.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Mar 2025 08:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742484584; x=1743089384;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FHzTTbYYErG3BHAoth3Rm1XEBwqah4VOUhcwHJtuowg=;
        b=is5aGeQl0touL+zH6g2fwbo9EpT2NLtKIfGLMv3i628MBNGbJyZn/K2BBDlNDVxLif
         d828JKf3qS/NBXXp0KGMS9POdd1Dsf3xFJSEZ0WKUaLYaFfrFoAKT3HMG8lUJO57/T73
         6qYsn/z7Nvz3fmp2jdyqapTCIdw8gKxn8M0RP1ktbxTx8gH0981zkBq5DXSUhMgQxPyT
         kepx25NDkCY6UsG9PyHpuuYpavvpuNE/0B6zgnXgKCKTLkcsgYznh4RzHXUBT/6984Pv
         aIU4g20vrRtv5NwsHCQ60oHnoHR1DhzYbbW9IuLIDmGcieGZ8braWtaYX2LQUzFwmuTX
         AlwA==
X-Forwarded-Encrypted: i=1; AJvYcCVVQeyB6bzS6RUyqKCIIv9eo5wqiwbe4AKCDpbF4hi1tFQVVB6cGEGOjA7czD+a4T7nWQ+QJws=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSNX3sIb9nOF1hlQhW6pBw67Ngi9KmAjcrW5h3qCcIj05BmObg
	jHIysh6ngtuqjnlHssl9QK+Zu12hqdz76TM7Sh9TdLGRT5pb2qtY5Z4oIIQMavUiPgwM9f5rypp
	Mb/OJPUMJ6vF7XbYNffRrP7zZNNRI1KlPIBXGRieIBGl9HUkgMHvzYQ==
X-Gm-Gg: ASbGncuYD0nGE4YayrG+HNL98kde+z8/OJFY4vokflJ59x2VOc/zH+UwgIagiAkeuoC
	C3zAUe+b3lAcPzlLusZruicnrev3/aB8DpqzWBeh/0dzVnWL1WDVEo8CGicEKr7gMlYeNYYV2lx
	c/zYSgwwpARohDxIvf2qaNFgdRnFPxX5GfOmtdwEYTGriJtIAQNMALDw4ofQ2/BE7tLdIuK0vm9
	+c6o5hIxx68LZ8qhnWghTE9VHCjWaWikzUx2+IEK7bn79bGR8dm9pgpTFCYIu0+yulAT7TI3IS8
	KAZUNyEkuf5ZzIYdAzHI2+ppGM4sNsCIk9PVUqxH9A3JYpKxanWXW7SX9JUFMGBN
X-Received: by 2002:a05:6000:1564:b0:390:e535:8770 with SMTP id ffacd0b85a97d-399739bca2emr8416847f8f.14.1742484584424;
        Thu, 20 Mar 2025 08:29:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXy+T6AX+SYujMTq96rpZX7KePBdG47XdfU/eRIThKezdv+D2LaJTOVhbidce5pfIbHAeHZQ==
X-Received: by 2002:a05:6000:1564:b0:390:e535:8770 with SMTP id ffacd0b85a97d-399739bca2emr8416824f8f.14.1742484583976;
        Thu, 20 Mar 2025 08:29:43 -0700 (PDT)
Received: from rh (p200300f6af11ec00f9928575aec32536.dip0.t-ipconnect.de. [2003:f6:af11:ec00:f992:8575:aec3:2536])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d3adc4488sm54468955e9.0.2025.03.20.08.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 08:29:43 -0700 (PDT)
Date: Thu, 20 Mar 2025 16:29:41 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
    qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org, 
    richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org, 
    oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com, 
    armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
    jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com, 
    mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 13/14] arm/cpu: Add sysreg generation scripts
In-Reply-To: <20250311162824.199721-14-cohuck@redhat.com>
Message-ID: <17649857-752b-a149-3935-5bcbd5c50627@redhat.com>
References: <20250311162824.199721-1-cohuck@redhat.com> <20250311162824.199721-14-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5vCzQ-cWzLQG6AwNrHs2hR1ES_GWH4o-jJ9MoSxv0RM_1742484584
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; format=flowed; charset=US-ASCII

On Tue, 11 Mar 2025, Cornelia Huck wrote:
> +++ b/scripts/gen-cpu-sysregs-header.awk
[...]
> +BEGIN {
> +    print ""
> +} END {
> +    print ""
> +}
> +
> +# skip blank lines and comment lines
> +/^$/ { next }
> +/^[\t ]*#/ { next }
> +
> +/^Sysreg\t/ || /^Sysreg /{
> +
> +	reg = $2
> +	op0 = $3
> +	op1 = $4
> +	crn = $5
> +	crm = $6
> +	op2 = $7
> +
> +	if (op0 == 3 && (op1>=0 && op1<=3) && crn==0 && (crm>=0 && crm<=7) && (op2>=0 && op2<=7)) {
> +	    idreg = 1
> +        } else {
> +	    idreg = 0
> +	}

This doesn't seem to be used. I guess this is in preparation for later
usage, when this can do more than just the plain register definition?

Sebastian

