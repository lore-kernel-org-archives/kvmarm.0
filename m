Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F6F4A8420
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 18:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791311573; cv=none; b=h3yVWN2SdlYexKj2XGliEGcpxtRdfHIes5FG1WPha5LRaJWJhnbU8b1K7jYZ/8ENPT3aEmqRUuZxhDQEZjQgU+7pbQf/ybq6lRWmVYqFXiupb/9sCP/JV/FlHC5b5Wmi0f9T0Gx4RBACQajYN4Y7ijdhaG7/d4UnjVNTulXh++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791311573; c=relaxed/simple;
	bh=PZoHwLAcac7MRG6rjhbSovKR0ePeapxARS7+LnV4ZIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+A7wx8qhGp1o6jlCtj21yVfJzS3K+/Kd5SvovET5omiVXZEfMlNM04ZffXVEG5wkEwLo02qGfGfRAcU4vZcR2imTuM+NBwDHe7TotdcFp6prd8fmyV/Yrv18As2rHR3Y97aU7rxsYVe207/Yz9sBSS1Xtj2Stm9Ij5zhmtRty8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dydOrpwR; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dydOrpwR"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2e40d62e77so107095266b.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 11:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311567; x=1791916367; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X/DDLaBldS6BCqOPBQL7QwFwyovqmKt8FALCheekTNg=;
        b=dydOrpwRhoayOKSdxBbUEyLgk6O9c5OxzsSw1xKCGB4IY30S4DIxUus1oXwfA1CBqs
         VTkD2tPF63wqmUYq3KYg6JEChAVE2MHoDH5EQkwtHyxKKYtbG2gdeRKfgC5H5UDEovbq
         JIQPP9LOBPBLImX235CN7SHMF7f166BHIO3R4k6JePYAuEC45bbiL3MBdR00eJn4MIio
         oI0v+k2iIuGJvNUa8fwpgk1E/W5d236A6WUIRP3yEnHcee98VH9Msu7faWZ43TVygPVa
         Y7PpoPE/bY9B3W8IVOCVjDSpS9pQyCpWHV7Nb9PhRPbhbY5Pxu9h855GCGcA4DWX/Y/A
         7aWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311567; x=1791916367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X/DDLaBldS6BCqOPBQL7QwFwyovqmKt8FALCheekTNg=;
        b=Eu7Lt31qw+x+5C4hiz41QooZf2Bv9r/JEIw/bJXyx5OX10c6x66HuNyD5wonuV7roR
         4JnmIeD+bv1OV7GzuUHgEf0lf2aOjOxnCMPreVPP5RbcxgC3fdi8LTBNPCpsWyw1pX3X
         wqlTUXE5q+7417phZujkz+hn2TPlsanPIS3LHPodRuemf+dbG0LEB91IU3gJoZhyK4e2
         mEqx3cvG6muC064YIBy+Al4BtxoyrJY3NWPDOhmlyIEoMboxlJCeb5p8ibTdkAUTqtN7
         LQ9s1C19ECuDuqb/IUwVMGvQ1rxFZHNkQlnKrrTFu3YloebHl9o+GZEArpg8HK86x2kH
         Ca/g==
X-Forwarded-Encrypted: i=1; AKwUvByHEv5bWd805ZIYndL2ujAG7K6DVxnq2dWdqXPrJbcpIdMAQuYxQXW1RdGWS5md+TU5vTHv4OQ=@lists.linux.dev
X-Gm-Message-State: AFuF++l3J3tGeLn1C3YzHh8oRRsu5lPWngxOJgIKMiO/i6G1TnI3y2qT
	8mwVXjbfOZE+bPNTDwb4vkuJ1G4wqbqnT3Zxcvqvzmy4+6y9BYRUvlIs
X-Gm-Gg: AYBFou2eHzmAggczikgorBxo1yL/ZuHGRtsUD3Q83F6thLC9n/lkErdCUoXO6s80oAy
	kv7fLYjl2NOI6IyeKVQtEI0Pe3VZu4r0Iwbda/BjYu2vkqfQTZOttOvXdRdN3h/w5dzs6Bm5IrT
	f5Z7fQqo6eZzd7ySuMzVJw/uR1iyp/5jNwzOyJuU4iAaC5vLeRHs3ix80OrvqQjAJuY5HTRX7al
	5UKO1O0iL7JIcsj8o0WLi84dZ1fT5fwRgM9d6i1eFgsm4hgxAK4DNt9xIKMPtvyZPsUHmK2sjPk
	WLcAeJdiKDfgU1pjT+bnw7Sv4jjIjHhQpIhcxJVKS79rji/UdKaigMLwyzHuaSGgKYsW84kQdg0
	4plHv9M7TdQfcUopij2tY4vLxzk+fMrymmmROCGlbuOMahFVm6/vJ9EzQbme3KhUx6M0R9h6var
	IlQzVmKA5Dm+DStN1UtMEIp/FvcgQ5rSnG4jv06U4AGmg5d3lQ53rpWlRKnu92jr5eLllmazTgJ
	GeZfbz15QlqOIVK0fAkq66+592MumVzDIDq7cQh1YdmcN7X6dPaC426/h1iGCFQwbXV+m/TESND
	LLKP6hygSqpCHrapi7bPOTlG1zldKjur7qA=
X-Received: by 2002:a17:907:72d3:b0:c2e:4488:b8a3 with SMTP id a640c23a62f3a-c316a0bb639mr232794566b.33.1791311566749;
        Tue, 06 Oct 2026 11:32:46 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:46 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 6/9] iommufd/selftest: Add mock-domain IOVA queries
Date: Tue,  6 Oct 2026 18:32:32 +0000
Message-ID: <20261006183235.16576-7-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

A test of memory that can be taken back or replaced does not know in
advance which frame a device reaches. IOMMU_TEST_OP_MD_CHECK_MAP only
compares against a known buffer.

Add MD_CHECK_MAPPED, which checks that a range is fully mapped or fully
unmapped, and MD_IOVA_TO_PHYS, which returns the frame behind an IOVA,
or 0 if it is unmapped. Both refuse an IOVA outside the domain's
aperture.

Both hold domains_rwsem for writing so that a userspace unmap cannot
free a page-table level during the walk.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/iommufd_test.h |  16 ++++
 drivers/iommu/iommufd/selftest.c     | 109 +++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/drivers/iommu/iommufd/iommufd_test.h b/drivers/iommu/iommufd/iommufd_test.h
index 52b78cbcc920..28fd9c43edc4 100644
--- a/drivers/iommu/iommufd/iommufd_test.h
+++ b/drivers/iommu/iommufd/iommufd_test.h
@@ -31,6 +31,8 @@ enum {
 	IOMMU_TEST_OP_PASID_CHECK_HWPT,
 	IOMMU_TEST_OP_DMABUF_GET,
 	IOMMU_TEST_OP_DMABUF_REVOKE,
+	IOMMU_TEST_OP_MD_CHECK_MAPPED,
+	IOMMU_TEST_OP_MD_IOVA_TO_PHYS,
 };
 
 enum {
@@ -193,6 +195,20 @@ struct iommu_test_cmd {
 			__s32 dmabuf_fd;
 			__u32 revoked;
 		} dmabuf_revoke;
+		struct {
+			/*
+			 * 1: every page in [iova, iova+length) must be mapped;
+			 * 0: none of them may be. Mixed is an error.
+			 */
+			__u32 mapped;
+			__u32 __reserved;
+			__aligned_u64 iova;
+			__aligned_u64 length;
+		} check_mapped;
+		struct {
+			__aligned_u64 iova;
+			__aligned_u64 out_phys;	/* 0 if unmapped */
+		} iova_to_phys;
 	};
 	__u32 last;
 };
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index af07c642a526..1f5cd2d00fda 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -2031,6 +2031,107 @@ static int iommufd_test_dmabuf_get(struct iommufd_ucmd *ucmd,
 	return rc;
 }
 
+/*
+ * True if [iova, iova + length) lies inside the domain's aperture.  Outside
+ * it the page table returns an error code from iova_to_phys(), not 0.
+ */
+static bool mock_domain_covers(struct mock_iommu_domain *mock,
+			       unsigned long iova, size_t length)
+{
+	struct iommu_domain_geometry *geo = &mock->domain.geometry;
+	unsigned long last;
+
+	if (check_add_overflow(iova, length - 1, &last))
+		return false;
+	return iova >= geo->aperture_start && last <= geo->aperture_end;
+}
+
+/*
+ * iova_to_phys() walks the page table, so it must not run while an unmap
+ * frees a level of it.  A userspace unmap holds the IOAS domains_rwsem for
+ * reading while it unmaps the domains, so holding it for writing keeps such
+ * unmaps away.  A memory provider or dma-buf revoke unmaps under its pages
+ * mutex only, so tests must not run these queries while a revoke of the
+ * range is in progress.
+ */
+static struct rw_semaphore *
+mock_domain_unmap_lock(struct iommufd_hw_pagetable *hwpt)
+{
+	return &to_hwpt_paging(hwpt)->ioas->iopt.domains_rwsem;
+}
+
+/*
+ * Report the physical address the mock domain resolves @iova to, or 0 if
+ * it is unmapped.  Lets a test check that two IOVAs share one frame, or that
+ * an IOVA moved to another frame, without knowing the frames in advance.
+ */
+static int iommufd_test_md_iova_to_phys(struct iommufd_ucmd *ucmd,
+					unsigned int mockpt_id,
+					unsigned long iova)
+{
+	struct iommu_test_cmd *cmd = ucmd->cmd;
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	unsigned int page_size;
+	int rc;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
+	if (iova % page_size || !mock_domain_covers(mock, iova, page_size)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+	down_write(mock_domain_unmap_lock(hwpt));
+	cmd->iova_to_phys.out_phys =
+		mock->domain.ops->iova_to_phys(&mock->domain, iova);
+	up_write(mock_domain_unmap_lock(hwpt));
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put:
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
+	return rc;
+}
+
+static int iommufd_test_md_check_mapped(struct iommufd_ucmd *ucmd,
+					unsigned int mockpt_id,
+					unsigned long iova, size_t length,
+					bool mapped)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	struct mock_iommu_domain *mock;
+	unsigned int page_size;
+	int rc = 0;
+
+	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
+	if (IS_ERR(hwpt))
+		return PTR_ERR(hwpt);
+
+	page_size = 1 << __ffs(mock->domain.pgsize_bitmap);
+	if (iova % page_size || length % page_size || !length ||
+	    !mock_domain_covers(mock, iova, length)) {
+		rc = -EINVAL;
+		goto out_put;
+	}
+
+	down_write(mock_domain_unmap_lock(hwpt));
+	for (; length; length -= page_size, iova += page_size) {
+		bool is_mapped =
+			mock->domain.ops->iova_to_phys(&mock->domain, iova) != 0;
+
+		if (is_mapped != mapped) {
+			rc = -ENOENT;
+			break;
+		}
+	}
+	up_write(mock_domain_unmap_lock(hwpt));
+
+out_put:
+	iommufd_put_object(ucmd->ictx, &hwpt->obj);
+	return rc;
+}
+
 static int iommufd_test_dmabuf_revoke(struct iommufd_ucmd *ucmd, int fd,
 				      bool revoked)
 {
@@ -2143,6 +2244,14 @@ int iommufd_test(struct iommufd_ucmd *ucmd)
 		return iommufd_test_dmabuf_revoke(ucmd,
 						  cmd->dmabuf_revoke.dmabuf_fd,
 						  cmd->dmabuf_revoke.revoked);
+	case IOMMU_TEST_OP_MD_CHECK_MAPPED:
+		return iommufd_test_md_check_mapped(ucmd, cmd->id,
+						    cmd->check_mapped.iova,
+						    cmd->check_mapped.length,
+						    cmd->check_mapped.mapped);
+	case IOMMU_TEST_OP_MD_IOVA_TO_PHYS:
+		return iommufd_test_md_iova_to_phys(ucmd, cmd->id,
+						    cmd->iova_to_phys.iova);
 	default:
 		return -EOPNOTSUPP;
 	}
