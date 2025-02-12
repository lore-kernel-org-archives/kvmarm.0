Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E16F209F5A
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 11:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739360505; cv=none; b=KfE9ovShQ99J9Q7DhejIVIJA4aOHUgOc7edy2Fsyv+IvNeqsJUa+LP8lAqePC9zSV8ddB+uKJw599915MaIIgt0Kl4P3hixT8H+lUQNa/HSk8i14kizMCSaJ8MQp31NVCJk15szOhksmuT3L7f/pxMmwfPbftwNIl/9/zyXDX8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739360505; c=relaxed/simple;
	bh=JeJ2jv2BwBrIa809Su81UECkCgacincdGK1guJn4zFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sj9ivpiM2ASNeEAnI0ppmMZPI4I2oSo6P48jzisac/uvSNs2+uJvT7wiRfUknbz6Uw9H5cL1+/U/bOrjsI9O8T1mCpqo8zgi3DRe2jurgiCDzGH5E9KChXevByida6qkOLhqz13OP6V9uWYdouIgdZ9MVwHh2kedqT7X1eP2zqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nUg7uXmJ; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nUg7uXmJ"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5de6069ceb5so1280033a12.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 03:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739360502; x=1739965302; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w0j3HfohIwJISbsXU0pbsmUuYrw+P0a5WGZgVgQVxGg=;
        b=nUg7uXmJIUCrERG3bjVNPl37T2ZgJ5zN4zU/nJGt90LAYWhwk7NDAYEjgMOvczwfUD
         oiNG1hWDQES82AJ9KBgpDWyLzLjzDEdSr+74+2zA9wQKhe8nlanGUk9l50g+TZX40P51
         q+91SFG5r9O79FssedaApFqmDUud/zq7s91QsrLNzELJ0fccmMOZinTxl+AxpQKOLIA8
         8UMll2uui2QvCojA/kyEgHqxpP3tiqtpyeG7nOtYrRCECPNhq54xTwc/Fy7UfrUOuxin
         RkCuRmxWBxJ444uMxWdCn3yp8uYBYcXfBaztexgGNVblZAVOuYy7fnnibMZZMk/Fy2e/
         8v+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739360502; x=1739965302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0j3HfohIwJISbsXU0pbsmUuYrw+P0a5WGZgVgQVxGg=;
        b=Yd7tGycIWfN6P5hvyehYzldhzVoYKIqMJee3yZCkpv4Y2Uw88WUqOQ+7Plpvti2OHA
         L8qpIcTId9Dx6tQZ8qkdssVyIyulEgAn909tvHsxMjstWh0o6jZx4TFSZKz/fnhmlaub
         PVxV2YpKVq+OOmBk3hnkAPkO6POE3KkbqRNGd5nbTWieOU7bz0JJBPW7sSQtU9pWVOpz
         h8AiDSNnoj4d5s3fRsRKJEGdRTeKIPUSqs6ENhVlXMBHyZeiKpdj+YetjLLf22XkPIct
         2vkyjfGAvKbuUTmUYZiWMxkNMfe4Fr4/EweN+ujN5r2G9kh2smoV8DCwZVzYWTTt+L7C
         fc3w==
X-Forwarded-Encrypted: i=1; AJvYcCVBzpC95owrE3KZ6JYMOabkhmKY+uG2HcgnGj+TAP7lPF0bXkR/ZxU3J3qiWQI5wl1FcKuhDdg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJeQ1TL47iSbBTQ+CwS0E//JtJfgtWezxZ3XkiakcMV96RpdqW
	65K3TcTfHzE45+N7v00i1W2aFnxHCtv5BMfC+xGxOTNS1G55fSC5uvrDw+VFyzc=
X-Gm-Gg: ASbGncs7gWzn/3CNjR42Zeek9US6T6RTP8yXRMEOj+zEFdj3+gY+WrX3qWgma6O7gqU
	CgGrcr8xr6s/NqZkg0W0MJGNDSORTGWlHUAkFIPj6MVl7baQprh2Lhvj2ehyZFZZ6kU7UNTFbzL
	T90tkYBNDDJncN9rk3uqQkQlSWeAZ3fwygqXaZSJWEORWACZ9ZlFRo+DrLwU9DR+eU8Z4DG12d7
	pXXpYpRUX9trNUixp5iW9660mWVzsszP862zwa8cWe4TMkm7dzUmM4RIjuFBHS8lY1rv594qKJJ
	hX2liTdYF+JpwQbgllrI
X-Google-Smtp-Source: AGHT+IGjOAjmf6XjmHjeaqxJH3+fWyGiM1rw3hi7aac7PC39lxHRaWXOjo/vo6+0foG0vbJvgDt8bQ==
X-Received: by 2002:a17:907:724c:b0:ab3:992d:d98d with SMTP id a640c23a62f3a-ab7dab331c9mr726269366b.0.1739360501945;
        Wed, 12 Feb 2025 03:41:41 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-ab772f893e9sm1267296966b.65.2025.02.12.03.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 03:41:41 -0800 (PST)
Date: Wed, 12 Feb 2025 14:41:38 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, kvmarm@lists.linux.dev,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>,
	virtualization@lists.linux.dev, Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Aishwarya TCV <Aishwarya.TCV@arm.com>
Subject: Re: kvm: nVHE hyp panic at: __kvm_nvhe_kvm_hyp_handle_sysre
Message-ID: <3902208d-8814-46fe-ba98-3db833b9a886@stanley.mountain>
References: <CA+G9fYt6Cuu6=OO9w80yhJbZB77Q0qf7nzYdvjbgDbgAw6t1jw@mail.gmail.com>
 <8634gku30g.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634gku30g.wl-maz@kernel.org>

On Tue, Feb 11, 2025 at 11:36:31AM +0000, Marc Zyngier wrote:
> For the crash at hand, which clearly shows nVHE, can you report
> whether the following hack fixes it for you?
> 
> 	M.

No luck, I'm afraid.  It still crashes the same way.

https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/anders/tests/2steTT4f2J8ZJjc3jNJFMuow9Cb

Click on "Logs: html" for the dmesg.

regards,
dan carpenter

> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index f838a45665f26..cb57420a07de2 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -556,7 +556,7 @@ static bool kvm_handle_cntxct(struct kvm_vcpu *vcpu)
>  		return false;
>  	}
>  
> -	val = compute_counter_value(ctxt);
> +	val = compute_counter_value(kern_hyp_va(ctxt));
>  
>  	vcpu_set_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu), val);
>  	__kvm_skip_instr(vcpu);
> 
> -- 
> Without deviation from the norm, progress is not possible.
