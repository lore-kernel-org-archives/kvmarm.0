Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BAB33C0
	for <kvmarm@lists.linux.dev>; Thu,  5 Jan 2023 21:48:31 +0000 (UTC)
Received: by mail-qv1-f49.google.com with SMTP id d13so26423038qvj.8
        for <kvmarm@lists.linux.dev>; Thu, 05 Jan 2023 13:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fe+gGPB5dV5QpThZtXGj+L3VR53amPF8Y92ESPgSHoI=;
        b=E6tIeJWWX3njOeFIFDhdzgUe8McsOkJuwxAbMqXNKLkUvJHTZp54V8CDp6DbgYSDjv
         LLC25+B7G7IzVndk2WdZvI3rj+6aCapAM0ObCEXTK+xrJK4bppqgkIqMfZYHwOWUUeTC
         wxpN6RPEuHjzoghv52wBUDsW2Mx9cfjCQ51SI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fe+gGPB5dV5QpThZtXGj+L3VR53amPF8Y92ESPgSHoI=;
        b=mf4Ko/RIcMlxs5vIaL9HBLRgAP5khGfyUC5nrgOATpRKkIqSra+UiUlCHY0mSLbte3
         TPOzgH58jpQBDKY17q3WmC1AFlJpPe4S4TGiKse77j+cMCQqA8SUx+E/oDSTe22bcnMu
         WqUMOxEqjNBJXp5Uawh8ToJFtew6gJ4H8hahFx0fi9TldaGC4/3aYPIElVPc91hPPX/d
         nJIU9GPUqjcRK+BFV0IPii4gXCaSR51mHjg/v8VAjg4kGFr44CT9CyMYCwh7HsRKwNTf
         Qf++8VzkANo4DZT/DakX6fNwD60CI3ElYdtWy+/UoI2ULBMd74a5EBu3BOtk0S9UW0Ys
         1Ryw==
X-Gm-Message-State: AFqh2kqop5nUc1yG17ALCl61sHCYbMOqiypGOc3QksH40Mp4YaHjzPAE
	rr1zca6MN2kLNRSJ4aY4YkxsdIUg6ikrptmT
X-Google-Smtp-Source: AMrXdXu4jfFc+oiYR6euM2fcEmLJwDAemZRWHNcMYVgKFrDhZuZKdN1LCethkgsdau8Fq77BZ8VYpQ==
X-Received: by 2002:a0c:ee2b:0:b0:4e3:6abf:ddb4 with SMTP id l11-20020a0cee2b000000b004e36abfddb4mr59377309qvs.23.1672955310453;
        Thu, 05 Jan 2023 13:48:30 -0800 (PST)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-7.dsl.bell.ca. [209.226.106.7])
        by smtp.gmail.com with ESMTPSA id h17-20020a05620a401100b006ce9e880c6fsm26976494qko.111.2023.01.05.13.48.29
        for <kvmarm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 13:48:30 -0800 (PST)
Date: Thu, 5 Jan 2023 16:48:28 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: kvmarm@lists.linux.dev
Subject: Test archive migration
Message-ID: <20230105214828.4ifp75dmp6idk6gy@meerkat.local>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello:

This message is to test the archive migration and replication. If everything
worked correctly, this message should shortly show up on
https://lore.kernel.org/kvmarm/.

-K
